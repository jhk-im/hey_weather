import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hey_weather/common/constants.dart';

class HeyWeatherTheme {
  HeyWeatherTheme(this.context);
  BuildContext context;

  ThemeData dark() => ThemeData(
        primaryColor: kPrimaryColor,
        primaryColorDark: kPrimaryDarkerColor,
        primaryColorLight: kPrimaryLighterColor,
        scaffoldBackgroundColor: kElevationColor,
        highlightColor: kTextDisabledColor,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        switchTheme: const SwitchThemeData(
          trackColor: WidgetStatePropertyAll(kPrimaryDarkerColor),
          trackOutlineWidth: WidgetStatePropertyAll(0),
        ),
        textSelectionTheme: const TextSelectionThemeData(
            selectionColor: kPrimaryDarkerColor,
            selectionHandleColor: kPrimaryDarkerColor,
            cursorColor: kPrimaryDarkerColor),
        inputDecorationTheme: InputDecorationTheme(
          // labelStyle: const TextStyle(
          //   color: kTextPointColor,
          //   fontFamily: kPretendardMedium,
          //   fontSize: 16,
          //   fontWeight: FontWeight.w400,
          // ),
          hintStyle: const TextStyle(
            color: kDividerPrimaryColor,
            fontFamily: kPretendardRegular,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          fillColor: kButtonColor,
          filled: true,
          contentPadding: const EdgeInsets.all(17.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Set
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Set
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          outlineBorder: const BorderSide(
            color: Colors.transparent,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Set
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      );

  ThemeData light() => ThemeData();
}
