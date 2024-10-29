import 'package:flutter/material.dart';
import 'package:SDriving/screens/settings_screen.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../services/speedometer_provider.dart';
import '../services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double temperature = 0.0;
  double humidity = 0.0;
  double windSpeed = 0.0;
  late FToast fToast;
  bool hasShownToast = false;
  bool isKmH = true;
  late Future<dynamic> weatherData;
  Timer? weatherTimer;
  String lastUpdated = 'Never';

  String getAdvice(double temperature, double humidity, double windSpeed) {
    if (temperature > 40 && humidity > 80 && windSpeed > 20) {
      return 'درجة الحرارة والرطوبة مرتفعتان جداً والرياح قوية. تجنب القيادة في هذه الظروف حيث قد تواجه صعوبة في السيطرة على السيارة، واهتم بشرب الماء بانتظام.';
    } else if (temperature > 40 && humidity > 80) {
      return 'درجة الحرارة والرطوبة مرتفعتان جداً. تأكد من شرب الماء بانتظام والقيادة ببطء لتجنب الإجهاد الحراري وتجنب القيادة لمسافات طويلة.';
    } else if (temperature > 40 && windSpeed > 20) {
      return 'درجة الحرارة مرتفعة جداً وهناك رياح قوية. قد تشعر بالتعب بسرعة في هذه الظروف، لذا تأكد من أخذ استراحات منتظمة.';
    } else if (temperature > 40) {
      return 'درجة الحرارة مرتفعة جداً. تأكد من شرب الماء بانتظام وتجنب القيادة لمسافات طويلة، واحرص على تشغيل مكيف الهواء.';
    } else if (temperature < 0 && humidity > 70 && windSpeed > 15) {
      return 'الجو بارد جداً مع رطوبة مرتفعة ورياح قوية. احذر من الانزلاق على الطرقات وتأكد من وجود إطارات مخصصة للثلج أو الجليد.';
    } else if (temperature < 0 && windSpeed > 15) {
      return 'الجو بارد جداً وهناك رياح قوية. تأكد من تشغيل التدفئة وارتداء ملابس دافئة، وتجنب القيادة السريعة في هذه الظروف.';
    } else if (temperature < 0) {
      return 'درجة الحرارة شديدة الانخفاض. تأكد من تشغيل التدفئة، وارتداء ملابس دافئة، واستخدام إطارات شتوية إذا كانت الظروف تتطلب ذلك. كن حذرًا من الجليد على الطرق.';
    } else if (humidity > 90 && windSpeed < 10) {
      return 'الرطوبة مرتفعة جداً مع رياح خفيفة، مما يزيد من فرصة تكاثف الضباب. احرص على تشغيل مساحات الزجاج الأمامي واستخدام المصابيح الأمامية.';
    } else if (humidity < 30 && windSpeed > 20) {
      return 'الجو جاف مع رياح قوية. قد يتسبب ذلك في تطاير الغبار وتقليل الرؤية. استخدم نظارات شمسية وابقِ نوافذ سيارتك مغلقة.';
    } else if (temperature >= 20 &&
        temperature <= 30 &&
        humidity < 60 &&
        windSpeed < 10) {
      return 'الجو مثالي للقيادة مع درجة حرارة معتدلة ورطوبة منخفضة ورياح خفيفة. تمتع برحلتك ولكن حافظ على الانتباه للطريق.';
    } else {
      return 'الظروف الجوية جيدة للقيادة. تمتع بالرحلة.';
    }
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    final speedometerProvider =
        Provider.of<SpeedometerProvider>(context, listen: false);
    speedometerProvider.getSpeedUpdates();

    _getLocationAndFetchWeather();
    weatherTimer = Timer.periodic(Duration(minutes: 30), (timer) {
      _getLocationAndFetchWeather();
    });
  }

  @override
  void dispose() {
    weatherTimer?.cancel();
    super.dispose();
  }

  Future<void> _getLocationAndFetchWeather() async {
    try {
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      weatherData =
          WeatherService().fetchWeather(position.latitude, position.longitude);

      weatherData.then((data) {
        if (data != null) {
          setState(() {
            // تحويل القيم إلى double
            temperature = data['main']['temp'].toDouble();
            humidity = data['main']['humidity'].toDouble();
            windSpeed = data['wind']['speed'].toDouble();
            lastUpdated = DateFormat('HH:mm').format(DateTime.now());
          });
        }
      });
    } catch (e) {
      _showToast("Failed to get location: $e");
    }
  }

  void _showToast(String message) {
    if (hasShownToast) return;

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(width: 12.0),
          Text(message),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );

    hasShownToast = true;

    Future.delayed(Duration(seconds: 10), () {
      hasShownToast = false;
    });
  }

  void toggleSpeedUnit() {
    setState(() {
      isKmH = !isKmH;
    });
  }

  @override
  Widget build(BuildContext context) {
    final speedometerProvider = Provider.of<SpeedometerProvider>(context);
    double currentSpeed = speedometerProvider.speedometer.currentSpeed;
    double totalDistance = speedometerProvider.speedometer.totalDistance;

    Color speedColor;
    String speedText;

    double displayedSpeed = isKmH ? currentSpeed : currentSpeed / 3.6;

    if (displayedSpeed == 0) {
      speedColor = Colors.grey;
      speedText = 'STOP';
    } else if (isKmH) {
      if (displayedSpeed > 0 && displayedSpeed <= 60) {
        speedColor = Colors.green;
        speedText = displayedSpeed.toStringAsFixed(1);
      } else if (displayedSpeed > 60 && displayedSpeed <= 100) {
        speedColor = Colors.yellow;
        speedText = displayedSpeed.toStringAsFixed(1);
      } else {
        speedColor = Colors.red;
        speedText = displayedSpeed.toStringAsFixed(1);
      }
    } else {
      if (displayedSpeed > 0 && displayedSpeed <= 60 / 3.6) {
        speedColor = Colors.green;
        speedText = displayedSpeed.toStringAsFixed(1);
      } else if (displayedSpeed > 60 / 3.6 && displayedSpeed <= 100 / 3.6) {
        speedColor = Colors.yellow;
        speedText = displayedSpeed.toStringAsFixed(1);
      } else {
        speedColor = Colors.red;
        speedText = displayedSpeed.toStringAsFixed(1);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SDriving',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body:
          buildBody(speedometerProvider, speedColor, speedText, totalDistance),
    );
  }

  Widget buildBody(SpeedometerProvider speedometerProvider, Color speedColor,
      String speedText, double totalDistance) {
    String speedUnit = isKmH ? 'km/h' : 'm/s';

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/background.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Speed',
                    style:
                        TextStyle(fontSize: 24, color: Colors.lightBlueAccent),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: toggleSpeedUnit,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.blueAccent, width: 5),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              speedText,
                              style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: speedColor),
                            ),
                            Text(
                              speedUnit,
                              style: TextStyle(fontSize: 24, color: speedColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Fuel Cost: ${speedometerProvider.calculateTotalFuelCost().toStringAsFixed(2)} EGP',
                    style:
                        TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Distance: ${totalDistance.toStringAsFixed(2)} km',
                    style:
                        TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      speedometerProvider.clearDistance();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Distance reset'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text('Reset Distance'),
                  ),
                  SizedBox(height: 20),
                  buildWeatherInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeatherInfo() {
    return FutureBuilder(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error fetching weather');
        } else {
          return Column(
            children: [
              Text(
                'Weather Information',
                style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
              ),
              SizedBox(height: 10),
              Text(
                'Temperature: ${temperature.toStringAsFixed(1)}°C',
                style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
              ),
              Text(
                'Humidity: ${humidity.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
              ),
              Text(
                'Wind Speed: ${windSpeed.toStringAsFixed(1)} m/s',
                style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent),
              ),
              Text(
                'Last Updated: $lastUpdated',
                style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
              ),
              Text(getAdvice(temperature, humidity, windSpeed)),
            ],
          );
        }
      },
    );
  }
}
