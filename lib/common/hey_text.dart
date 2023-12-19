import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';


class HeyText extends Text {

  const HeyText(super.data, {
    super.key,
    super.style,
    super.textAlign,
  });

  factory HeyText.bodyBold(String text, Color? color, double? fontSize) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardBold,
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  factory HeyText.bodySemiBold(String text, Color? color, double? fontSize) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardSemiBold,
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  factory HeyText.bodyMedium(String text, Color? color, double? fontSize) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardMedium,
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  factory HeyText.bodyRegular(String text, Color? color, double? fontSize) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color,
        fontSize: fontSize,
      ),
    );
  }

  factory HeyText.bodyLight(String text, Color? color, double? fontSize) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardLight,
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}