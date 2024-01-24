import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';

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
            ImageUtils.icon(
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
