import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/theme.dart';
import 'package:hey_weather/getx/bindings/init_binding.dart';
import 'package:hey_weather/getx/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    final theme = HeyWeatherTheme(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'title'.tr,
      defaultTransition: Transition.cupertino,
      fallbackLocale: const Locale('ko', 'KR'),
      themeMode: ThemeMode.dark,
      theme: theme.light(),
      darkTheme: theme.dark(),
      getPages: Routes.pages,
      initialRoute: Routes.routeRoot,
      initialBinding: InitBinding(),
    );
  }
}
