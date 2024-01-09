import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';


class HeyText extends Text {

  const HeyText(super.data, {
    super.key,
    super.style,
    super.textAlign,
  });

  // Regular
  factory HeyText.caption2(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont11,
      ),
    );
  }

  factory HeyText.caption1(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont12,
      ),
    );
  }

  factory HeyText.footnote(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont13,
      ),
    );
  }

  factory HeyText.subHeadline(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont15,
      ),
    );
  }

  factory HeyText.callOut(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont16,
      ),
    );
  }

  factory HeyText.body(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont17,
      ),
    );
  }

  factory HeyText.title3(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont20,
      ),
    );
  }

  factory HeyText.title2(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont22,
      ),
    );
  }

  factory HeyText.title1(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont28,
      ),
    );
  }

  factory HeyText.largeTitle(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardRegular,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont34,
      ),
    );
  }

  // Semi Bold
  factory HeyText.footnoteSemiBold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardSemiBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont13,
      ),
    );
  }

  factory HeyText.subHeadlineSemiBold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardSemiBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont15,
      ),
    );
  }

  factory HeyText.callOutSemiBold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardSemiBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont16,
      ),
    );
  }

  factory HeyText.bodySemiBold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardSemiBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont17,
      ),
    );
  }

  // Bold
  factory HeyText.title3Bold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont20,
      ),
    );
  }

  factory HeyText.title2Bold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? fontSize ?? kFont22,
      ),
    );
  }

  factory HeyText.title1Bold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont28,
      ),
    );
  }

  factory HeyText.largeTitleBold(String text, {Color? color, double? fontSize}) {
    return HeyText(
      text,
      style: TextStyle(
        fontFamily: kPretendardBold,
        color: color ?? Colors.white,
        fontSize: fontSize ?? kFont34,
        height: 1.2,
        
      ),

    );
  }
}