import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/buttons/hey_weather_address_button.dart';
import 'package:hey_weather/widgets/cards/hey_weather_select_card.dart';

import 'image_utils.dart';

class HeyBottomSheet {
  /*static void showCommonDialog(BuildContext context, {
    String title = '',
    String subtitle = '',
    String description = '',
    String okText = '확인',
    String cancel = '취소',
    String userId = '',
    bool isCancel = true,
    Function? onOk,
  }) {
    double width = MediaQuery.of(context).size.width - 40;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: kBlackColor.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: width < 760 ? width : 760,
                padding: const EdgeInsets.only(top:24, right: 16, left: 16, bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: kWhiteColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ThunderText.bodyMedium14(title, kBlackColor),
                    ),
                    const Divider(color: kGreyFourColor, height: 1),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          ThunderText.bodyRegular14(
                            subtitle,
                            kBlackColor,
                            textAlign: TextAlign.center,
                          ),
                          if (userId.isNotEmpty) ... {
                            Container(
                              width: double.maxFinite,
                              margin: const EdgeInsets.only(top:8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kWhiteTwoColor,
                                border: Border.all(
                                  color: kGreyFourColor,
                                  width: 1, // Adjust the border width as needed
                                ),
                              ),
                              child: ThunderText.bodyMedium14(
                                userId,
                                kBlackColor,
                                textAlign: TextAlign.center,
                              ),
                            )
                          } else ... {
                            if (description.isNotEmpty) ... {
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: ThunderText.bodyRegular13(
                                  description,
                                  kGreyColor,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            }
                          },
                        ],
                      ),
                    ),

                    Row(
                      children: [
                        if (isCancel) ... {
                          Expanded(
                            child: ThunderOutlineButton.text(
                              outlineColor: kBlackColor,
                              foregroundColor: kBlackColor,
                              height: 44,
                              onPressed: () {
                                Get.back();
                              },
                              text: ThunderText.bodySemiBold16(cancel, kBlackColor),
                            ),
                          ),
                          const SizedBox(width: 8,),
                        },
                        Expanded(
                          child: ThunderOutlineButton.text(
                            backgroundColor: kAccentColor,
                            foregroundColor: kBlackColor,
                            outlineColor: kBlackColor,
                            height: 44,
                            onPressed: () {
                              if (onOk != null) {
                                onOk.call();
                              }
                            },
                            text: ThunderText.bodySemiBold16(okText, kBlackColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }*/

  static void showOnBoardingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: kButtonColor,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title, Close Button
              Container(
                margin: const EdgeInsets.only(top: 20, left: 20, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: HeyText.title3Bold(
                        'bs_onboard_title'.tr,
                        fontSize: kFont18,
                        color: kTextPointColor,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: ImageUtils.icon(context, 'close', width: 32, height: 32),
                    ),
                  ],
                ),
              ),
              // Subtitle
              Container(
                margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                child: HeyText.body(
                  'bs_onboard_subtitle'.tr,
                  fontSize: kFont18,
                  color: kTextDisabledColor,
                ),
              ),
              // Selector
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 32),
                child: Center(
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      // 습도
                      HeyWeatherSelectCard(
                        title: 'humidity'.tr,
                        iconName: 'humidity',
                      ),
                      // 바람
                      HeyWeatherSelectCard(
                        title: 'wind'.tr,
                        iconName: 'wind',
                      ),
                      // 강수
                      HeyWeatherSelectCard(
                        title: 'rain'.tr,
                        iconName: 'rain',
                      ),
                      // 자외선
                      HeyWeatherSelectCard(
                        title: 'ultraviolet'.tr,
                        iconName: 'ultraviolet',
                      ),
                      // 미세먼지
                      HeyWeatherSelectCard(
                        title: 'fine_dust'.tr,
                        iconName: 'fine_dust',
                      ),
                      // 초 미세먼지
                      HeyWeatherSelectCard(
                        title: 'ultra_fine_dust'.tr,
                        iconName: 'fine_dust',
                      ),
                      // 일출 일몰
                      HeyWeatherSelectCard(
                        title: 'sunrise_sunset'.tr,
                        iconName: 'sunrise_sunset',
                      ),
                      // 시간대별 날씨
                      HeyWeatherSelectCard(
                        title: 'weather_by_time'.tr,
                        iconName: 'weather_by_time',
                      ),
                      // 주간 날씨
                      HeyWeatherSelectCard(
                        title: 'weather_week'.tr,
                        iconName: 'weather_week',
                      ),
                    ],
                  ),
                ),
              ),
              // Button
              Container(
                margin: const EdgeInsets.all(20),
                child: HeyElevatedButton.primaryText1(
                  text: 'to_add'.tr,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showAddressBottomSheet(BuildContext context, {
    required List<Address> addressList,
    required currentAddress,
    Function? onSelectedAddress,
  }) {
    double maxHeight = (MediaQuery.of(context).size.height) * 0.7;
    bool isScroll = maxHeight - 142 < 54 * addressList.length;
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      backgroundColor: kButtonColor,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title, Close Button

                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: HeyText.title3Bold(
                          addressList.length > 1
                              ? 'bs_address_title_1'.tr
                              : 'bs_address_title_2'.tr,
                          fontSize: kFont18,
                          color: kTextPointColor,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: ImageUtils.icon(context, 'close', width: 32, height: 32),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Selector
                Expanded(
                  flex: isScroll ? 1 : 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(var address in addressList) ... {
                          HeyWeatherAddressButton(
                            address: address,
                            isSelected: currentAddress == address.id,
                            onSelectedAddress: (addressId) {
                              onSelectedAddress?.call(addressId);
                              Get.back();
                            },
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Button
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: HeyCustomButton.textIcon(
                      context,
                      iconName: 'arrow_right',
                      text: 'bs_address_btn'.tr,
                      onPressed: () {

                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}