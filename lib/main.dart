import 'package:SDriving/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'services/permission_service.dart'; // استيراد PermissionService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PermissionService permissionService = PermissionService();

  try {
    // طلب إذن الموقع
    await permissionService.requestLocationPermission();
  } catch (e) {
    // التعامل مع الخطأ في حال فشل طلب الإذن
    print('Failed to get permission: $e');
  }

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: false),
      home: const SplashScreen(),
      title: 'SDriving',
    );
  }
}
