import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeySnackBar {
  static show(BuildContext context, String message, {bool isCheckIcon = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: kTextPointColor.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isCheckIcon) ... {
                SvgUtils.icon(
                  context,
                  'circle_check_selected',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
              },
              HeyText.bodySemiBold(
                message,
                color: kTextPrimaryColor,
                fontSize: kFont15,
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
        showCloseIcon: false,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}