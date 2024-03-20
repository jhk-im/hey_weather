import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';

class HeyDialog {

  static void showCommonDialog(BuildContext context, {
    String title = '',
    String subtitle = '',
    String okText = '확인',
    String cancelText = '취소',
    Function? onOk,
  }) {
    double width = MediaQuery.of(context).size.width - 54;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: width,
                padding: const EdgeInsets.only(top:24, right: 16, left: 16, bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kButtonColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: HeyText.callOutSemiBold(
                        title,
                        fontSize: 18,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 12, left: 8),
                      child: Column(
                        children: [
                          HeyText.subHeadline(
                            subtitle,
                            color:kTextDisabledColor,
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 48),
                      child: Row(
                        children: [
                          Expanded(
                            child: HeyElevatedButton.primaryText1(
                              height: 56,
                              backgroundColor: kIconColor,
                              foregroundColor: kTextSecondaryColor,
                              onPressed: () {
                                Get.back();
                              },
                              text: cancelText,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: HeyElevatedButton.primaryText1(
                              height: 56,
                              onPressed: () {
                                if (onOk != null) {
                                  Get.back();
                                  onOk.call();
                                }
                              },
                              text: okText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}