import 'dart:convert'; // لاستيراد مكتبة JSON لتحليل البيانات
import 'package:http/http.dart' as http; // لاستيراد مكتبة HTTP للقيام بالاستدعاءات
import 'package:cloud_firestore/cloud_firestore.dart'; // لاستيراد مكتبة Firestore لتخزين البيانات

class WeatherService {
  // API Key الخاص بك للحصول على بيانات الطقس
  final String apiKey = 'b85d82b5526546b9be1fdccca46ba3f8';

  // عنوان قاعدة بيانات API للطقس
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // دالة لجلب بيانات الطقس بناءً على خطوط العرض والطول
  Future<Map<String, dynamic>?> fetchWeather(double latitude, double longitude) async {
    try {
      // استدعاء API للحصول على بيانات الطقس
      final response = await http.get(Uri.parse('$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        // إذا كانت الاستجابة ناجحة (حالة 200)، قم بتحليل البيانات
        Map<String, dynamic> weatherData = json.decode(response.body); // تحليل استجابة JSON

        // تخزين بيانات الطقس في Firestore
        await saveWeatherData(latitude, longitude, weatherData);

        return weatherData; // إرجاع بيانات الطقس
      } else {
        print('Error: ${response.statusCode}'); // طباعة رسالة الخطأ في حالة وجود مشكلة
        return null; // في حالة وجود خطأ، إرجاع null
      }
    } catch (e) {
      print('Failed to load weather data: $e'); // طباعة الخطأ إذا فشل الاستدعاء
      return null; // في حالة حدوث استثناء، إرجاع null
    }
  }

  // دالة لتخزين بيانات الطقس في Firestore
  Future<void> saveWeatherData(double latitude, double longitude, Map<String, dynamic> weatherData) async {
    // الحصول على مجموعة "weather" في Firestore
    CollectionReference weatherCollection = FirebaseFirestore.instance.collection('weather');

    // إضافة مستند جديد إلى المجموعة
    await weatherCollection.add({
      'latitude': latitude, // تخزين خطوط العرض
      'longitude': longitude, // تخزين خطوط الطول
      'data': weatherData, // تخزين بيانات الطقس
      'timestamp': FieldValue.serverTimestamp(), // تسجيل تاريخ ووقت التحديث باستخدام الوقت من الخادم
      'dateTime': DateTime.now().toIso8601String(), // تسجيل التاريخ والوقت الحالي كـ ISO 8601
    });
  }
}
