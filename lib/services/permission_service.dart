import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// طلب إذن الموقع
  Future<void> requestLocationPermission() async {
    // تحقق من حالة الإذن
    PermissionStatus status = await Permission.location.status;

    // إذا لم يتم منح الإذن، اطلبه من المستخدم
    if (status.isDenied) {
      status = await Permission.location.request();
    }

    // تحقق من حالة الإذن بعد الطلب
    if (status.isGranted) {
      print("Location permission granted");
      // يمكنك استخدام الموقع هنا
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied");
      // توجيه المستخدم إلى إعدادات التطبيق لتمكين الإذن
      openAppSettings();
    } else {
      print("Location permission denied");
      // يمكن إضافة منطق إضافي هنا للتعامل مع الحالة
    }
  }
}
