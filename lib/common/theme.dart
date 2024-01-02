import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hey_weather/common/constants.dart';

class HeyWeatherTheme {
  HeyWeatherTheme(this.context);
  BuildContext context;

  ThemeData dark() => ThemeData(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kElevationColor,

    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    switchTheme: const SwitchThemeData(
      trackColor: MaterialStatePropertyAll(kPrimaryDarkerColor),
      trackOutlineWidth: MaterialStatePropertyAll(0),
    ),
  );

  ThemeData light() => ThemeData();
}