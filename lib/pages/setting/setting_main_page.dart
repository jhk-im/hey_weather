import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_bottom_sheet.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/pages/setting/setting_main_controller.dart';
import 'package:hey_weather/widgets/loading_widget.dart';

class SettingMainPage extends GetView<SettingMainController> {
  const SettingMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Obx(() => Stack(
              children: [
                // 헤더, 설정 리스트, 커피
                Column(
                  children: [
                    // 헤더
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // back
                          InkWell(
                            splashColor: kBaseColor,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () {
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 20),
                              child: SvgUtils.icon(
                                context,
                                'arrow_left',
                                color: kTextPrimaryColor,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),

                          // 타이틀
                          const Spacer(),
                          HeyText.bodySemiBold(
                            'setting'.tr,
                            color: kTextPrimaryColor,
                          ),
                          const Spacer(),
                          const SizedBox(width: 64)
                        ],
                      ),
                    ),

                    // 지역 설정
                    InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        Get.toNamed(Routes.routeAddress);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            HeyText.body(
                              'setting_location'.tr,
                              color: kTextPrimaryColor,
                            ),
                            const Spacer(),
                            SvgUtils.icon(context, 'arrow_right', color: kIconColor),
                          ],
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Divider(color: kButtonColor, height: 1),
                    ),

                    // 알림 설정
                    InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () async {
                        var result = await Get.toNamed(Routes.routeSettingNotification);

                        if (result) {
                          controller.updateNotification();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            HeyText.body(
                              'setting_notification'.tr,
                              color: kTextPrimaryColor,
                            ),
                            const Spacer(),
                            HeyText.bodySemiBold(
                              controller.isNotificationPermission ? 'on'.tr : 'off'.tr,
                              color: controller.isNotificationPermission ? kTextPrimaryColor : kDividerPrimaryColor,
                            ),
                            const SizedBox(width: 8),
                            SvgUtils.icon(context, 'arrow_right', color: kIconColor),
                          ],
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Divider(color: kButtonColor, height: 1),
                    ),

                    // 온도 설정
                    InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        HeyBottomSheet.showTemperatureBottomSheet(
                          context,
                          isFahrenheit: controller.isFahrenheit,
                          onSelected: controller.fahrenheitToggle,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            HeyText.body(
                              'setting_temperature'.tr,
                              color: kTextPrimaryColor,
                            ),
                            const Spacer(),
                            HeyText.bodySemiBold(
                              controller.isFahrenheit ? 'fahrenheit'.tr : 'celsius'.tr,
                              color: kTextPrimaryColor,
                            ),
                            const SizedBox(width: 8),
                            SvgUtils.icon(context, 'arrow_right', color: kIconColor),
                          ],
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Divider(color: kButtonColor, height: 1),
                    ),

                    // 의견 보내기
                    InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {

                      },
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            HeyText.body(
                              'send_opinion'.tr,
                              color: kTextPrimaryColor,
                            ),
                            const Spacer(),
                            SvgUtils.icon(context, 'arrow_right', color: kIconColor),
                          ],
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Divider(color: kButtonColor, height: 1),
                    ),
                  ],
                ),

                LoadingWidget(controller.isLoading),
              ],
            )),
          ),
        );
      },
    );
  }

}

