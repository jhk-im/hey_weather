import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/search_address.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/buttons/hey_weather_address_button.dart';
import 'package:hey_weather/widgets/cards/hey_weather_home_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_select_card.dart';

import 'svg_utils.dart';

class HeyBottomSheet {

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
                      child: SvgUtils.icon(context, 'close', width: 32, height: 32),
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

  static void showSelectAddressBottomSheet(BuildContext context, {
    required List<Address> addressList,
    required currentAddress,
    Function? onSelectedAddress,
    Function? onMoveToAddress,
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
                        child: SvgUtils.icon(context, 'close', width: 32, height: 32),
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
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: HeyCustomButton.textIcon(
                      context,
                      iconName: 'arrow_right',
                      text: 'bs_address_btn'.tr,
                      onPressed: () {
                        Get.back();
                        onMoveToAddress?.call();
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

  static void showCreateAddressBottomSheet(BuildContext context, {
    required SearchAddress address,
    String? weatherStatus,
    String? temperature,
    String? message1,
    String? message2,
    String? message3,
    required Function onCreateAddress,
  }) {
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
            height: 580,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Title, Close Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          HeyText.title3Bold(
                            address.addressName ?? '',
                            fontSize: kFont18,
                            color: kPrimaryDarkerColor,
                          ),
                          HeyText.title3Bold(
                            Utils.hasKoreanFinalConsonant(address.addressName ?? '') ? 'question_add_1'.tr : 'question_add_2'.tr,
                            fontSize: kFont18,
                            color: kTextPointColor,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgUtils.icon(context, 'close', width: 32, height: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Card
                HeyWeatherHomeCard(
                  weatherStatus: weatherStatus,
                  temperature: temperature,
                  message1: message1,
                  message2: message2,
                  message3: message3,
                ),
                const SizedBox(height: 32),
                // Add Button
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: HeyElevatedButton.primaryText1(
                    text: 'to_add'.tr,
                    onPressed: () {
                      onCreateAddress.call(address);
                    },
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