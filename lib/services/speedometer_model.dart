class Speedometer {
  double currentSpeed; // السرعة الحالية
  double time10_30; // الوقت في النطاق من 10 إلى 30
  double time30_10; // الوقت في النطاق من 30 إلى 10
  double totalDistance; // المسافة الإجمالية
  SpeedRange range; // النطاق الحالي

  Speedometer({
    required this.currentSpeed,
    required this.time10_30,
    required this.time30_10,
    this.totalDistance = 0, // القيمة الافتراضية للمسافة الإجمالية
    this.range = SpeedRange.LESS_10, // القيمة الافتراضية للنطاق
  });
}

enum SpeedRange {
  LESS_10,
  FROM_10_TO_30,
  FROM_30_TO_10,
  OVER_30,
}
