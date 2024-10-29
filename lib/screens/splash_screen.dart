import 'package:flutter/material.dart';
import 'package:SDriving/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(alignment: Alignment.center, children: [
              Image.asset(
                'assets/start.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment(0, 0.75), // تحديد الموقع في الربع الرابع
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(122, 0, 132, 119),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(200, 48),
                    shadowColor: const Color.fromARGB(194, 0, 243, 227),
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ])));
  }
}
