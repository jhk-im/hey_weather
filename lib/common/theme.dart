import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hey_weather/common/constants.dart';

class HeyWeatherTheme {
  HeyWeatherTheme(this.context);
  BuildContext context;

  ThemeData dark() => ThemeData(
    primaryColor: const Color(0xFF5C94FF), // primary base
    primaryColorDark: const Color(0xFF1968FF), // primary darker
    primaryColorLight: const Color(0xFF99BCFF), // primary lighter
    scaffoldBackgroundColor: const Color(0xFF17171B), // background base, contents
    dividerColor: const Color(0xFF404048), // divider base
    disabledColor: const Color(0xFFA1A1A3), // text disabled
    indicatorColor: const Color(0xFF62626C), // background icon

    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      foregroundColor: Color(0xFFE4E4E5),
      backgroundColor: Color(0xFF17171B),
    ),

    colorScheme: ColorScheme(
      brightness: Brightness.dark,

      error: const Color(0xFFD73333),
      onError: const Color(0xFFD73333).withOpacity(0.5),

      primary: const Color(0xFF5C94FF), // primary base
      onPrimary: const Color(0xFF101012).withOpacity(0.5),

      primaryContainer: const Color(0xFF101012), // background elevation

      secondary: const Color(0xFFFFE55C), // sub
      onSecondary: const Color(0xFF101012).withOpacity(0.5),

      background: const Color(0xFF17171B), // background base, contents
      onBackground: const Color(0xFF101012).withOpacity(0.5),

      surface: const Color(0xFF202027), // background button, divider secondary
      onSurface: const Color(0xFF101012).withOpacity(0.5),

    ),

    textTheme: const TextTheme(
      // Caption2
      labelSmall: TextStyle(
        fontSize: 11,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardRegular,
      ),

      // Caption1
      labelMedium: TextStyle(
        fontSize: 12,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardRegular,
      ),

      // Footnote
      labelLarge: TextStyle(
        fontSize: 13,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardRegular,
      ),

      // CallOut
      bodySmall: TextStyle(
        fontSize: 15,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardRegular,
      ),

      // Body
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardRegular,
      ),

      bodyLarge: TextStyle(
        fontSize: 17,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardRegular,
      ),

      // SubHeadline
      headlineSmall: TextStyle(
        fontSize: 15,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardSemiBold,
      ),

      // Headline
      headlineMedium: TextStyle(
        fontSize: 17,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardSemiBold,
      ),

      // Title3
      headlineLarge: TextStyle(
        fontSize: 20,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardBold,
      ),

      // Title2
      titleSmall: TextStyle(
        fontSize: 22,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardBold,
      ),

      // Title1
      titleMedium: TextStyle(
        fontSize: 28,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardBold,
      ),

      // LargeTitle
      titleLarge: TextStyle(
        fontSize: 34,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardBold,
      ),


      displaySmall: TextStyle(
        fontSize: 13,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardLight,
      ),

      // Body
      displayMedium: TextStyle(
        fontSize: 15,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardLight,
      ),

      displayLarge: TextStyle(
        fontSize: 17,
        color: Color(0xFFE4E4E5),
        fontFamily: kPretendardLight,
      ),
    ),
  );

  ThemeData light() => ThemeData();
}