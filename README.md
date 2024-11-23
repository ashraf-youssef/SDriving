# About project:

The "SDriving" application is an application that contributes to reducing the risk of accidents by providing the user with data related to driving such as speed, weather, and their advice.

تطبيق "SDriving" هو تطبيق يساهم في الحد من مخاطر الحوادث عن طريق تزويد المستخدم بالبيانات المتعلقة بالقيادة مثل السرعة و الطقس و النصائح الخاصة بهما.
# Team Members:

1. Ashraf Youssef Ahmed (Team Leader)
2. Youssef Mohamed Mahmoud (Site Services Officer)
3. Hager Hussein Fouad (Designer)
4. Walid Salam Ibrahim Mohamed (programmer)


# Steps to build the project:

1- Setup and UI Design
2- API Integration and Forecast Display
3- Location Tracking and Notifications
4- Final Testing and Deployment


# Core Technologies:

The provided Flutter code leverages several key technologies to create a comprehensive driving application:
Flutter: As the primary framework, Flutter enables the creation of cross-platform mobile applications with a single codebase. It provides a rich set of widgets and tools for building user interfaces.
Provider: This state management solution is used to manage the app's state, such as the current speed, fuel consumption, and weather data. It helps in sharing data between different parts of the application.

3. Geolocator: This plugin is used to determine the device's current location, which is essential for fetching weather data based on the user's geographical coordinates.
4. http: This package is used to make HTTP requests to fetch weather data from a weather API.
5. intl: This package provides internationalization and localization features, allowing the app to display dates, numbers, and other locale-specific data in the user's preferred format.
6. shared_preferences: This package is used to store local data, such as user preferences (e.g., dark mode, unit preferences).
7. fluttertoast: This plugin is used to display toast messages to the user, providing feedback for actions like saving settings or errors.
8. Cross-Platform Frameworks
9. API Integration
10. Push Notifications
11. Database: Firebase
12. Design Images: Canava tool for design

# User guide of the app:

1. Home screen:
The main screen is the screen where the program displays the features for which we created the application to improve the user experience and to provide the following services by referring to the images on the application for the main page:
1- Current speed with changing the color of the speed numbers from green to red after a speed of 100 kilometers per hour to warn the driver.
2- Temperature, humidity and wind speed to calculate weather conditions and inform the user of the necessary settings for driving, health and personal safety
3- In the current update that we are working on, the temperature, humidity and wind speed are used to provide scientific advice based on the interaction of these factors with the driver and the car
4. Display and calculate the cost of the driving trip starting from opening the application according to the cost of a liter of gasoline that the user enters as it changes from one fuel to another and from one consumption to another as well as the distance traveled per liter for the user's car

# layouts of the app:

1. Home screen:
الشاشة الرئيسية هي الشاشة التي يعرض البرنامج فيها المميزات التي من أجلها أنشأنا التطبيق لتحسين تجربة المستخدم و ذلك لتقديم الخدمات التالية بالإشارة إلى الصور على التطبيق للصفحة الرئيسية :
1- السرعة الحالية مع تغيير اللون لأرقام السرعة من التدرج الأخضر إلى التدرج الأحمر بعد سرعة 100 كيلومتر في الساعة إنذار السائق.
2- درجة الحرارة و الرطوبة و سرعة الرياح و ذلك لحساب الاحوال الجويه و إفادة المستخدم بالاعدادات اللازمة للقيادة و الصحة و السلامة الشخصية (في التحديث الحالي الذي نعمل عليه هو استخدام درجة الحرارة والرطوبة وسرعة الرياح لتقديم نصائح علمية مبنية على تفاعل هذه العوامل مع السائق و السيارة )
3- عرض وحساب تكلفة الرحلة للقيادة بداية من فتح التطبيق و ذلك طبقا لتكلفة لتر البنزين التي يدخلها المستخدم حيث أنها تتغير من وقود الى آخر و من استهلاك لآخر وكذلك المسافة المقطوعة لكل لتر بالنسبة لسيارة المستخدم

2. Settings screen:
The settings screen is the screen that controls changing the application variables, such as allowing dark or light mode, changing the price of gasoline, and changing the number of kilometers the car travels per liter according to each individual’s consumption.
شاشة الاعدادات هي الشاشة المتحكمة في تغيير المتغيرات للتطبيق مثل السماحية بالوضع الداكن او الفاتح و تغيير سعر البنزين وتغيير عدد الكيلوات التي تقطعها السيارة لكل لتر حسب استهلاك كل فرد

