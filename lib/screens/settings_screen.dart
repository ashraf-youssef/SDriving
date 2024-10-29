import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SDriving/services/speedometer_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // متحكمات نصية لإدارة مدخلات المستخدم
  final TextEditingController _priceController =
      TextEditingController(); // لسعر اللتر
  final TextEditingController _distancePerLiterController =
      TextEditingController(); // للمسافة المقطوعة باللتر
  bool isDarkMode = true; // متغير للتحكم في وضع الألوان

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Set valus'),
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(alignment: Alignment.center, children: [
              Image.asset(
                'assets/background.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // حقل إدخال لسعر اللتر
                        TextField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price per liter', // نص التسمية للحقل
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.black), // لون النص
                          keyboardType: TextInputType.number, // نوع الإدخال عدد
                        ),
                        // حقل إدخال للمسافة المقطوعة باللتر
                        TextField(
                          controller: _distancePerLiterController,
                          decoration: InputDecoration(
                            labelText: 'Distance per liter', // نص التسمية للحقل
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.black), // لون النص
                          keyboardType: TextInputType.number, // نوع الإدخال عدد
                        ),
                        SizedBox(height: 20), // مساحة فارغة بين العناصر
                        // زر لحفظ القيم
                        ElevatedButton(
                          onPressed: () {
                            // تحويل النص إلى قيم عددية
                            double pricePerLiter =
                                double.tryParse(_priceController.text) ?? 0;
                            double distancePerLiter = double.tryParse(
                                    _distancePerLiterController.text) ??
                                0;

                            // تحديث تكلفة الوقود
                            Provider.of<SpeedometerProvider>(context,
                                    listen: false)
                                .updateFuelCost(
                                    pricePerLiter, distancePerLiter);

                            Navigator.pop(context); // العودة إلى الصفحة السابقة
                          },
                          child: Text('Save',
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.lightBlueAccent
                                      : Colors.black)),
                          // تخصيص لون الزر
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[300]),
                        ),
                      ]))
            ])));
  }
}
