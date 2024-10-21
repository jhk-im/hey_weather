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
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Builder(
      builder: (context) {
        return Scaffold(
          body: Obx(() => Stack(
                children: [
                  // 헤더, 설정 리스트, 커피
                  Column(
                    children: [
                      // StatusBar
                      SizedBox(height: statusBarHeight),

                      // 헤더
                      SizedBox(
                        width: double.maxFinite,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // back
                            GestureDetector(
                              onTap: () {
                                Get.back(result: controller.isUpdate);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 24, bottom: 24, left: 16, right: 20),
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
                      GestureDetector(
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
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  height: 20,
                                ),
                              ),
                              SvgUtils.icon(context, 'arrow_right',
                                  color: kIconColor),
                            ],
                          ),
                        ),
                      ),

                      /*// Divider
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(color: kButtonColor, height: 1),
                  ),

                  // 알림 설정
                  GestureDetector(
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
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              height: 20,
                            ),
                          ),
                          HeyText.bodySemiBold(
                            controller.isNotificationPermission ? 'on'.tr : 'off'.tr,
                            color: controller.isNotificationPermission ? kTextPrimaryColor : kDividerPrimaryColor,
                          ),
                          const SizedBox(width: 8),
                          SvgUtils.icon(context, 'arrow_right', color: kIconColor),
                        ],
                      ),
                    ),
                  ),*/

                      // Divider
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Divider(color: kButtonColor, height: 1),
                      ),

                      // 온도 설정
                      GestureDetector(
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
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  height: 20,
                                ),
                              ),
                              HeyText.bodySemiBold(
                                controller.isFahrenheit
                                    ? 'fahrenheit'.tr
                                    : 'celsius'.tr,
                                color: kTextPrimaryColor,
                              ),
                              const SizedBox(width: 8),
                              SvgUtils.icon(context, 'arrow_right',
                                  color: kIconColor),
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
                      GestureDetector(
                        onTap: controller.sendEmail,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              HeyText.body(
                                'send_opinion'.tr,
                                color: kTextPrimaryColor,
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  height: 20,
                                ),
                              ),
                              SvgUtils.icon(context, 'arrow_right',
                                  color: kIconColor),
                            ],
                          ),
                        ),
                      ),

                      // Divider
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Divider(color: kButtonColor, height: 1),
                      ),

                      // 응원의 커피
                      /*Container(
                    margin: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: controller.moveToCoffee,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kBaseColor,
                        ),
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeyText.footnoteSemiBold(
                                  'coffee_title_1'.tr,
                                  color: kPrimaryLighterColor,
                                ),
                                HeyText.footnoteSemiBold(
                                  'coffee_title_2'.tr,
                                  color: kTextPointColor,
                                ),
                              ],
                            ),
                            const Spacer(),
                            SvgUtils.icon(
                              context,
                              'arrow_right',
                              color: kTextPointColor,
                              width: 16,
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: statusBarHeight),
                    child: LoadingWidget(controller.isLoading),
                  ),
                ],
              )),
        );
      },
    );
  }
}
