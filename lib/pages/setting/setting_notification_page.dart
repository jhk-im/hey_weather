import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/pages/setting/setting_notification_controller.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_switch.dart';
import 'package:hey_weather/widgets/loading_widget.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

class SettingNotificationPage extends GetView<SettingNotificationController> {
  const SettingNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Obx(() => Stack(
              children: [
                // 헤더, 알림 토글, 알림 리스트
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
                              Get.back(result: controller.isUpdated);
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
                            'setting_notification'.tr,
                            color: kTextPrimaryColor,
                          ),
                          const Spacer(),

                          // 편집
                          InkWell(
                            splashColor: kBaseColor,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: controller.editModeToggle,
                            child: Container(
                              width: 72,
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  HeyText.body(
                                    controller.isEditMode ? 'done'.tr : 'edit'.tr,
                                    color: kTextDisabledColor,
                                    fontSize: kFont18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 알림 토글
                    Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 20, left: 20, right: 20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: kBaseColor,
                      ),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          HeyText.body('receive_notification'.tr),
                          const Spacer(),
                          HeyCustomSwitch(
                            onChange: controller.notificationPermissionToggle,
                            isSelected: controller.isNotificationPermission,
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Visibility(
                      visible: controller.isNotificationPermission,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Divider(color: kButtonColor, height: 1),
                      ),
                    ),

                    // 알림 리스트
                    Visibility(
                      visible: controller.isNotificationPermission,
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // 리스트
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.notificationList.length,
                                itemBuilder: (context, index) {
                                  final dateTime = Utils().formatDateTime(DateTime.parse(controller.notificationList[index].dateTime ?? '')).split(' ');
                                  return Container(
                                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                    child: Row(
                                      children: [
                                        if (controller.isEditMode) ... {
                                          GestureDetector(
                                            onTap: () {
                                              controller.removeNotification(controller.notificationList[index]);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 16),
                                              child: SvgUtils.icon(context, 'circle_minus'),
                                            ),
                                          ),
                                        },

                                        Expanded(
                                          child: GestureDetector(
                                            onTap: controller.isEditMode ? () {
                                              final currentTime = DateTime.parse(controller.notificationList[index].dateTime ?? '');
                                              picker.DatePicker.showTime12hPicker(
                                                context,
                                                showTitleActions: true,
                                                locale: LocaleType.ko,
                                                theme: const picker.DatePickerTheme(
                                                  backgroundColor: kButtonColor,
                                                  itemStyle: TextStyle(color: kTimePickerItem, fontSize: 16, fontFamily: kPretendardRegular),
                                                  cancelStyle: TextStyle(color: kIconColor, fontSize: 16, fontFamily: kPretendardRegular),
                                                  doneStyle: TextStyle(color: kPrimaryDarkerColor, fontSize: 16, fontFamily: kPretendardRegular),
                                                ),
                                                onConfirm: (date) {
                                                  controller.updateNotification(index, date.toString(), controller.notificationList[index]);
                                                },
                                                currentTime: currentTime,
                                              );
                                            } : null,
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: kBaseColor,
                                              ),
                                              width: double.maxFinite,
                                              child: Row(
                                                children: [
                                                  HeyText.title2(dateTime[0], color: kTextSecondaryColor),
                                                  const SizedBox(width: 6),
                                                  HeyText.largeTitle(dateTime[1], color: kTextPrimaryColor),
                                                  const Spacer(),
                                                  if (controller.isEditMode) ... {
                                                    Container(
                                                      margin: const EdgeInsets.only(right: 14),
                                                      child: SvgUtils.icon(context, 'arrow_right'),
                                                    ),
                                                  } else ... {
                                                    Container(
                                                      margin: const EdgeInsets.only(right: 20),
                                                      child: HeyCustomSwitch(
                                                        onChange: (selected) {
                                                          controller.notificationToggle(index, controller.notificationList[index]);
                                                        },
                                                        isSelected: controller.notificationList[index].isOn == true,
                                                      ),
                                                    ),
                                                  },
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // 추가 버튼
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: InkWell(
                                  splashColor: kBaseColor,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onTap: () {
                                    final now = DateTime.now();
                                    DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour);
                                    picker.DatePicker.showTime12hPicker(
                                      context,
                                      showTitleActions: true,
                                      locale: LocaleType.ko,
                                      theme: const picker.DatePickerTheme(
                                        backgroundColor: kButtonColor,
                                        itemStyle: TextStyle(color: kTimePickerItem, fontSize: 16, fontFamily: kPretendardRegular),
                                        cancelStyle: TextStyle(color: kIconColor, fontSize: 16, fontFamily: kPretendardRegular),
                                        doneStyle: TextStyle(color: kPrimaryDarkerColor, fontSize: 16, fontFamily: kPretendardRegular),
                                      ),
                                      onConfirm: (date) {
                                        controller.createNotification(date.toString());
                                      },
                                      currentTime: currentTime,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: kBaseColor,
                                    ),
                                    width: double.maxFinite,
                                    height: 56,
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        SvgUtils.icon(
                                          context,
                                          'plus',
                                          width: 16,
                                          height: 16,
                                          color: kTextSecondaryColor,
                                        ),
                                        const SizedBox(width: 4),
                                        HeyText.subHeadline('add'.tr, color: kTextSecondaryColor),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

