import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // مكتبة الموقع
import 'package:connectivity_plus/connectivity_plus.dart'; // مكتبة الاتصال
import 'package:fluttertoast/fluttertoast.dart'; // استيراد مكتبة Fluttertoast
import 'package:logger/logger.dart'; // استيراد مكتبة Logger
import 'speedometer_model.dart'; // استيراد نموذج السرعة

// إنشاء مثيل من Logger
final Logger logger = Logger();

class SpeedometerProvider with ChangeNotifier {
  Speedometer _speedometer = Speedometer(
    currentSpeed: 0,
    time10_30: 0,
    time30_10: 0,
    totalDistance: 0,
  );

  Stopwatch _stopwatch = Stopwatch();
  Position? _previousPosition; // متغير لتخزين الموقع السابق
  double _totalDistance = 0; // متغير لتخزين المسافة الإجمالية
  bool _isConnected = true; // متغير لحالة الاتصال

  // بيانات الوقود
  double _fuelCostPerLiter = 0; // سعر لتر البنزين
  double _distancePerLiter = 0; // المسافة التي يستهلكها 1 لتر

  Speedometer get speedometer => _speedometer;
  bool get isConnected => _isConnected; // Getter لحالة الاتصال

  /// تحقق من خدمة الموقع وحالة الأذونات
  Future<bool> checkLocationServiceAndPermissionStatus() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logger.e('Location services are disabled.');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          logger.e('Location permission denied');
          return false; // الأذونات غير مُعطاة
        }
      }
      return true; // الأذونات مُعطاة
    } catch (e) {
      logger.e('Error checking location permissions: $e');
      return false; // في حالة حدوث خطأ، نعيد false
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      logger.e('No internet connection.');
      _isConnected = false; // تحديث حالة الاتصال
      notifyListeners(); // إعلام الواجهة بالتغيير
      return false;
    }
    _isConnected = true; // الاتصال متوفر
    notifyListeners(); // إعلام الواجهة بالتغيير
    return true;
  }

  void updateSpeed(Position position) {
    double speed = (position.speed) * 3.6; // تحويل إلى كم/ساعة
    speed = speed.isNaN ? 0 : speed; // تعيين السرعة إلى 0 إذا كانت NaN

    _speedometer.currentSpeed = speed;

    // حساب المسافة إذا كان هناك موقع سابق
    if (_previousPosition != null) {
      double distance = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      _totalDistance += distance; // إضافة المسافة إلى المسافة الإجمالية
      _speedometer.totalDistance =
          _totalDistance / 1000; // تحويل المسافة إلى كيلومترات
    }

    _previousPosition = position; // تحديث الموقع السابق

    if (speed >= 10 && speed <= 30) {
      checkSpeedAndMeasureTimeWhileInRange(speed);
    } else {
      checkSpeedAndMeasureTimeWhileOutOfRange(speed);
    }

    notifyListeners(); // إشعار التحديثات
  }

  Future<void> getSpeedUpdates() async {
    if (await checkLocationServiceAndPermissionStatus() &&
        await checkInternetConnection()) {
      Geolocator.getPositionStream().listen((Position position) {
        updateSpeed(position);
      });
    } else {
      logger.e('Permission denied or location service disabled or no internet');
      Fluttertoast.showToast(
        msg: "يرجى التأكد من تفعيل خدمة GPS والاتصال بالإنترنت.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void checkSpeedAndMeasureTimeWhileInRange(double vehicleSpeed) {
    if (vehicleSpeed >= 10) {
      if (_speedometer.range == SpeedRange.LESS_10) {
        _speedometer.range = SpeedRange.FROM_10_TO_30;
        _stopwatch.start();
      }
      _speedometer.time10_30 = _stopwatch.elapsed.inSeconds.toDouble();
    }

    if (vehicleSpeed <= 30) {
      if (_speedometer.range == SpeedRange.OVER_30) {
        _speedometer.range = SpeedRange.FROM_30_TO_10;
        _stopwatch.start();
      }
      _speedometer.time30_10 = _stopwatch.elapsed.inSeconds.toDouble();
    }
  }

  void checkSpeedAndMeasureTimeWhileOutOfRange(double vehicleSpeed) {
    if (vehicleSpeed < 10) {
      if (_speedometer.range == SpeedRange.FROM_30_TO_10 ||
          _speedometer.range == SpeedRange.FROM_10_TO_30) {
        _stopwatch.stop();
        _speedometer.time10_30 = _stopwatch.elapsed.inSeconds.toDouble();
        _stopwatch.reset();
        _speedometer.range = SpeedRange.LESS_10; // تغيير الحالة إلى أقل من 10
      }
    }

    if (vehicleSpeed > 30) {
      if (_speedometer.range == SpeedRange.FROM_10_TO_30 ||
          _speedometer.range == SpeedRange.FROM_30_TO_10) {
        _stopwatch.stop();
        _speedometer.time30_10 = _stopwatch.elapsed.inSeconds.toDouble();
        _stopwatch.reset();
        _speedometer.range = SpeedRange.OVER_30; // تغيير الحالة إلى أكثر من 30
      }
    }
  }

  // تحديث بيانات الوقود
  void updateFuelCost(double pricePerLiter, double distancePerLiter) {
    if (pricePerLiter < 0 || distancePerLiter <= 0) {
      logger.e('Invalid fuel cost or distance per liter.');
      return; // تجنب القيم غير الصالحة
    }

    _fuelCostPerLiter = pricePerLiter;
    _distancePerLiter = distancePerLiter;
    notifyListeners(); // إعلام الواجهة بالتغيير
  }

  // حساب تكلفة الوقود الإجمالية
  double calculateTotalFuelCost() {
    double totalDistance =
        _speedometer.totalDistance; // المسافة الإجمالية بالكيلومترات
    if (_distancePerLiter == 0) return 0; // تجنب القسمة على صفر
    return (totalDistance / _distancePerLiter) *
        _fuelCostPerLiter; // حساب التكلفة
  }

  // دالة إعادة تعيين المسافة
  void clearDistance() {
    _totalDistance = 0; // إعادة تعيين المسافة الإجمالية
    _speedometer.totalDistance = 0; // تحديث نموذج السرعة
    notifyListeners(); // إعلام الواجهة بالتغيير
  }
}
