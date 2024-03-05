import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class Utils {
  static int getIconIndex({String rainStatus = '없음', String skyStatus = '', int currentTime = 0, int sunrise = 0, int sunset = 0}) {
    int iconIndex = 0;
    if (rainStatus == '없음') {
      switch (skyStatus) {
        case '맑음' :
          if (currentTime > sunrise && currentTime < sunset) {
            iconIndex = 2;
          } else {
            iconIndex = 3;
          }
        case '구름많음' :
          if (currentTime > sunrise && currentTime < sunset) {
            iconIndex = 4;
          } else {
            iconIndex = 5;
          }
        case '흐림' :
          iconIndex = 6;
      }
    } else {
      switch (rainStatus) {
        case '비' || '소나기' || '빗방울' || '비/눈' || '빗방울/눈날림' :
          iconIndex = 0;
        case '눈' || '눈날림' :
          iconIndex = 1;
      }
    }

    return iconIndex;
  }

  static double calculateWindChill(double temperature, double windSpeed) {
    if (temperature >= 10.0) {
      return temperature;
    } else {
      return 13.12 + (0.6215 * temperature) - (11.37 * pow(windSpeed, 0.16)) +
          (0.3965 * temperature * pow(windSpeed, 0.16));
    }
  }

  static String convertToTime(String number) {
    int time = int.parse(number);
    int hour = time ~/ 100;
    int minute = time % 100;
    if (hour > 12) {
      hour = hour - 12;
    }
    return '$hour시 $minute분';
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No Internet Connection
    } else {
      return true; // Connected to the Internet
    }
  }

  static bool hasKoreanFinalConsonant(String text) {
    final koreanRegExp = RegExp('[가-힣]');

    if (text.isEmpty || !koreanRegExp.hasMatch(text)) {
      return false;  // 한글이 아닌 경우
    }

    final lastChar = text.characters.last;
    final lastCharCode = lastChar.codeUnitAt(0);

    return (lastCharCode - 0xAC00) % 28 != 0;
  }

  String containsSearchText(String? input, String search) {
    if (input != null) {
      final list = input.split(' ');
      if (list.toString().contains(search)) {
        return list.lastWhere((e) => e.contains(search));
      } else {
        return list.last;
      }
    } else {
      return '';
    }
  }

  String formatDateTime(DateTime dateTime) {
    final String formattedTime = DateFormat('a h:mm').format(dateTime);
    final String korAmPm = formattedTime.contains('AM') ? '오전' : '오후';
    return formattedTime.replaceFirst(RegExp('[APMapm]{2}'), korAmPm);
  }

  static String convertToTimeFormat(String str) {
    int hour = int.parse(str.substring(0, 2));
    String period = (hour < 12) ? '오전' : '오후';
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }
    return '$period $hour시';
  }

  static int celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5 + 32).toInt();
  }

  static String getCurrentTimeInHHFormat() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH').format(now);
    return '${formattedTime}00';
  }
}