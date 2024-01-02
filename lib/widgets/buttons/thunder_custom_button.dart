import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';

class HeyCustomButton extends Container {
  HeyCustomButton({
    super.key,
    super.child,
    super.margin,
    super.decoration,
    super.width,
    super.padding,
    super.height,
  });

  factory HeyCustomButton.text({
    required Widget text,
    Function? onPressed,
  }) {

    return HeyCustomButton(
      child: GestureDetector(
        onTap: () {
          onPressed?.call();
        },
        child: text,
      ),
    );
  }

  factory HeyCustomButton.icon({
    required Widget icon,
    Function? onPressed,
  }) {

    return HeyCustomButton(
      child: GestureDetector(
        onTap: () {
          onPressed?.call();
        },
        child: icon,
      ),
    );
  }

  factory HeyCustomButton.tag({
    required Widget text,
    double paddingVertical = 6.0,
    double paddingHorizontal = 8.0,
    double radius = 6.0,
    Color backgroundColor = kPrimaryColor,
    Function? onPressed,
  }) {

    return HeyCustomButton(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      child: GestureDetector(
        onTap: () {
          onPressed?.call();
        },
        child: text,
      ),
    );
  }
}
