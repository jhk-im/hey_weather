import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyElevatedButton extends ElevatedButton {
  const HeyElevatedButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.style,
  });

  // Text1
  factory HeyElevatedButton.primaryText1({
    Color backgroundColor = kPrimaryDarkerColor,
    Color foregroundColor = Colors.white,
    double height = 56,
    double radius = 16,
    double horizontalPadding = 16,
    double fontSize = 17,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        fixedSize: Size(double.maxFinite, height),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kButtonColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
      child: HeyText.bodySemiBold(
        text ?? '',
        fontSize: fontSize,
        color: onPressed != null ? Colors.white : kIconColor,
      ),
    );
  }

  // Text2
  factory HeyElevatedButton.primaryText2({
    Color backgroundColor = kPrimaryDarkerColor,
    Color foregroundColor = Colors.white,
    double height = 40,
    double radius = 12,
    double horizontalPadding = 16,
    double fontSize = 15,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        //fixedSize: Size(double.maxFinite, height),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kButtonColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
      child: HeyText.subHeadlineSemiBold(
        text ?? '',
        fontSize: fontSize,
        color: onPressed != null ? Colors.white : kIconColor,
      ),
    );
  }

  factory HeyElevatedButton.secondaryText2({
    Color backgroundColor = kButtonColor,
    Color foregroundColor = kTextSecondaryColor,
    double height = 40,
    double radius = 12,
    double horizontalPadding = 16,
    double fontSize = 15,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kBaseColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
      child: HeyText.subHeadlineSemiBold(
        text ?? '',
        fontSize: fontSize,
        color: onPressed != null ? kTextSecondaryColor : kIconColor,
      ),
    );
  }

  // Text3
  factory HeyElevatedButton.primaryText3({
    Color backgroundColor = kPrimaryDarkerColor,
    Color foregroundColor = Colors.white,
    double height = 32,
    double radius = 52,
    double horizontalPadding = 16,
    double fontSize = 13,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        //fixedSize: Size(double.maxFinite, height),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kButtonColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
      child: HeyText.footnoteSemiBold(
        text ?? '',
        fontSize: fontSize,
        color: onPressed != null ? Colors.white : kIconColor,
      ),
    );
  }

  factory HeyElevatedButton.secondaryText3({
    Color backgroundColor = kButtonColor,
    Color foregroundColor = kTextSecondaryColor,
    double height = 32,
    double radius = 52,
    double horizontalPadding = 16,
    double fontSize = 13,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        //fixedSize: Size(double.maxFinite, height),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kButtonColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
      child: HeyText.footnoteSemiBold(
        text ?? '',
        fontSize: fontSize,
        color: onPressed != null ? kTextSecondaryColor : kIconColor,
      ),
    );
  }

  // Icon1
  factory HeyElevatedButton.secondaryIcon1(BuildContext context, {
    Color backgroundColor = kButtonColor,
    Color foregroundColor = kTextSecondaryColor,
    double height = 56,
    double radius = 16,
    double horizontalPadding = 16,
    double fontSize = 17,
    String? iconName,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        fixedSize: Size(double.maxFinite, height),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kBaseColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
      child: Row(
        children: [
          const Spacer(),
          SvgUtils.icon(
            context,
            iconName ?? 'plus',
            width: 16,
            height: 16,
            color: onPressed != null ? kTextSecondaryColor : kIconColor,
          ),
          const SizedBox(width: 8),
          HeyText.body(
            text ?? '',
            fontSize: fontSize,
            color: onPressed != null ? kTextSecondaryColor : kIconColor,
          ),
          const Spacer(),
        ],
      )
    );
  }

  // Icon2
  factory HeyElevatedButton.secondaryIcon2(BuildContext context, {
    Color backgroundColor = kButtonColor,
    Color foregroundColor = kTextSecondaryColor,
    double? width,
    double height = 40,
    double radius = 12,
    double horizontalPadding = 16,
    double fontSize = 15,
    String? iconName,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        minimumSize: Size(width ?? double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kBaseColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,
      ),
      child: SvgUtils.icon(
        context,
        iconName ?? 'plus',
        width: 16,
        height: 16,
        color: onPressed != null ? kTextSecondaryColor : kIconColor,
      ),
    );
  }

  // Icon3
  factory HeyElevatedButton.primaryIcon3(BuildContext context, {
    Color backgroundColor = kPrimaryDarkerColor,
    Color foregroundColor = Colors.white,
    double height = 40,
    double radius = 12,
    double horizontalPadding = 16,
    double fontSize = 15,
    bool isLeftIcon = false,
    String? iconName,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kButtonColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const Spacer(),
          if (isLeftIcon) ... {
            SvgUtils.icon(
              context,
              iconName ?? 'plus',
              width: 16,
              height: 16,
              color: onPressed != null ? Colors.white : kIconColor,
            ),
            const SizedBox(width: 8),
          },
          HeyText.subHeadlineSemiBold(
            text ?? '',
            fontSize: fontSize,
            color: onPressed != null ? Colors.white : kIconColor,
          ),
          if (!isLeftIcon) ... {
            const SizedBox(width: 8),
            SvgUtils.icon(
              context,
              iconName ?? 'plus',
              width: 16,
              height: 16,
              color: onPressed != null ? Colors.white : kIconColor,
            ),
          },
          //const Spacer(),
        ],
      ),
    );
  }

  factory HeyElevatedButton.secondaryIcon3(BuildContext context, {
    Color backgroundColor = kButtonColor,
    Color foregroundColor = kTextSecondaryColor,
    double height = 40,
    double radius = 12,
    double horizontalPadding = 16,
    double fontSize = 15,
    bool isLeftIcon = false,
    String? iconName,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        disabledBackgroundColor: kBaseColor,
        disabledForegroundColor: kIconColor,
        splashFactory: NoSplash.splashFactory,

      ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const Spacer(),
            if (isLeftIcon) ... {
              SvgUtils.icon(
                context,
                iconName ?? 'plus',
                width: 16,
                height: 16,
                color: onPressed != null ? kTextSecondaryColor : kIconColor,
              ),
              const SizedBox(width: 8),
            },
            HeyText.subHeadlineSemiBold(
              text ?? '',
              fontSize: fontSize,
              color: onPressed != null ? kTextSecondaryColor : kIconColor,
            ),
            if (!isLeftIcon) ... {
              const SizedBox(width: 8),
              SvgUtils.icon(
                context,
                iconName ?? 'plus',
                width: 16,
                height: 16,
                color: onPressed != null ? kTextSecondaryColor : kIconColor,
              ),
            },
            //const Spacer(),
          ],
        ),
    );
  }

  // Popup
  factory HeyElevatedButton.primaryPopup({
    Color backgroundColor = kPrimaryDarkerColor,
    Color foregroundColor = Colors.white,
    double height = 56,
    double radius = 16,
    double horizontalPadding = 16,
    double fontSize = 15,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: () {
        onPressed?.call();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        fixedSize: Size(double.maxFinite, height),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        splashFactory: NoSplash.splashFactory,

      ),
      child: HeyText.subHeadlineSemiBold(
        text ?? '',
        fontSize: fontSize,
        color: Colors.white,
      ),
    );
  }

  factory HeyElevatedButton.secondaryPopup({
    Color backgroundColor = kIconColor,
    Color foregroundColor = kTextSecondaryColor,
    double height = 56,
    double radius = 12,
    double horizontalPadding = 16,
    double fontSize = 16,
    String? text,
    Function? onPressed}) {
    return HeyElevatedButton(
      onPressed: onPressed != null ? () {
        onPressed.call();
      } : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor.withAlpha(15),
        fixedSize: Size(double.maxFinite, height),
        minimumSize: Size(double.minPositive, height),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Set the corner radius here
        ),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        splashFactory: NoSplash.splashFactory,
      ),
      child: HeyText.subHeadlineSemiBold(
        text ?? '',
        fontSize: fontSize,
        color: kTextSecondaryColor
      ),
    );
  }
}