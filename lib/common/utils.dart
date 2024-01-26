import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class Utils {
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
}