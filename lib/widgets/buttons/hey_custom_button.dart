import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

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

  factory HeyCustomButton.textIcon(BuildContext context, {
    double fontSize = 15,
    Color color = kTextSecondaryColor,
    String? iconName,
    String? text,
    Function? onPressed,
  }) {

    return HeyCustomButton(
      child: GestureDetector(
        onTap: () {
          onPressed?.call();
        },
        child: Row(
          children: [
            const Spacer(),
            HeyText.subHeadlineSemiBold(
              text ?? '',
              fontSize: fontSize,
              color: onPressed != null ? kTextSecondaryColor : kIconColor,
            ),
            const SizedBox(width: 8),
            SvgUtils.icon(
              context,
              iconName ?? 'arrow_right',
              width: 16,
              height: 16,
              color: color,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  factory HeyCustomButton.tag({
    required Widget text,
    double paddingVertical = 6,
    double paddingHorizontal = 8,
    double radius = 6,
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

  factory HeyCustomButton.outlineTag({
    required Widget text,
    double paddingVertical = 4,
    double paddingHorizontal = 10,
    double radius = 20,
    Color backgroundColor = Colors.transparent,
    Color outlineColor = kDividerPrimaryColor,
    Function? onPressed,
  }) {

    return HeyCustomButton(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: outlineColor,
          width: 1, // 외곽선 두께
        ),
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

  factory HeyCustomButton.tagWithIcon(BuildContext context, {
    required String iconName,
    required String text,
    double paddingTop = 8,
    double paddingBottom = 8,
    double paddingLeft = 10,
    double paddingRight = 16,
    double iconMargin = 10,
    double radius = 12,
    Color backgroundColor = kButtonColor,
    Function? onPressed,
  }) {

    return HeyCustomButton(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: GestureDetector(
        onTap: () {
          onPressed?.call();
        },
        child: Row(
          children: [
            SvgUtils.icon(context, iconName, width: 28, height: 28),
            SizedBox(width: iconMargin),
            HeyText.footnoteSemiBold(
              text,
              color: kTextSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
