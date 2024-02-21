import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/local/model/search_address.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/buttons/hey_weather_address_button.dart';
import 'package:hey_weather/widgets/cards/hey_weather_home_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_select_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_dust_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_small_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_sun_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_time_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_ultraviolet_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_week_card.dart';

import 'svg_utils.dart';

class HeyBottomSheet {

  static void showOnBoardingBottomSheet(BuildContext context, {Function? onAdd}) {
    double height = (MediaQuery.of(context).size.height) - 97;

    Map<String, bool> weatherSelectMap = {
      kWeatherCardTime: false,
      kWeatherCardWeek: false,
      kWeatherCardDust: false,
      kWeatherCardRain: false,
      kWeatherCardHumidity: false,
      kWeatherCardFeel: false,
      kWeatherCardWind: false,
      kWeatherCardSun: false,
      kWeatherCardUltraviolet: false,
    };

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
          child: SizedBox(
            height: height,
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
                  margin: const EdgeInsets.only(top: 12, bottom: 16, left: 20, right: 20),
                  child: HeyText.body(
                    'bs_onboard_subtitle'.tr,
                    fontSize: kFont18,
                    color: kTextDisabledColor,
                  ),
                ),
                // Selector
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 32),
                      child: Center(
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            // 시간대별 날씨
                            HeyWeatherSelectCard(
                              id: kWeatherCardTime,
                              title: 'weather_by_time'.tr,
                              iconName: 'weather_by_time',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 주간 날씨
                            HeyWeatherSelectCard(
                              id: kWeatherCardWeek,
                              title: 'weather_week'.tr,
                              iconName: 'weather_week',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 대기질
                            HeyWeatherSelectCard(
                              id: kWeatherCardDust,
                              title: 'dust'.tr,
                              iconName: 'dust',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 강수
                            HeyWeatherSelectCard(
                              id: kWeatherCardRain,
                              title: 'rain'.tr,
                              iconName: 'rain',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 습도
                            HeyWeatherSelectCard(
                              id: kWeatherCardHumidity,
                              title: 'humidity'.tr,
                              iconName: 'humidity',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 체감온도
                            HeyWeatherSelectCard(
                              id: kWeatherCardFeel,
                              title: 'feel_temp'.tr,
                              iconName: 'feel_temp',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 바람
                            HeyWeatherSelectCard(
                              id: kWeatherCardWind,
                              title: 'wind'.tr,
                              iconName: 'wind',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 일출 일몰
                            HeyWeatherSelectCard(
                              id: kWeatherCardSun,
                              title: 'sunrise_sunset'.tr,
                              iconName: 'sunrise_sunset',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                            // 자외선
                            HeyWeatherSelectCard(
                              id: kWeatherCardUltraviolet,
                              title: 'ultraviolet'.tr,
                              iconName: 'ultraviolet',
                              onSelect: (id, selected) {
                                weatherSelectMap[id] = selected;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Button
                Container(
                  margin: const EdgeInsets.all(20),
                  child: HeyElevatedButton.primaryText1(
                    text: 'to_add'.tr,
                    onPressed: () {
                      List<String> selectIds = weatherSelectMap.entries
                          .where((entry) => entry.value == true)
                          .map((entry) => entry.key)
                          .toList();
                      Get.back();
                      onAdd?.call(selectIds);
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

  static void showAddWeatherBottomSheet(BuildContext context, List<String> idList, {
    Function? onConfirm,
    int ultraviolet = 0,
    String sunrise = '',
    String sunset = '',
  }) {
    double height = (MediaQuery.of(context).size.height) - 97;

    Map<String, bool> weatherInitMap = {
      kWeatherCardTime: true,
      kWeatherCardWeek: true,
      kWeatherCardDust: true,
      kWeatherCardRain: true,
      kWeatherCardHumidity: true,
      kWeatherCardFeel: true,
      kWeatherCardWind: true,
      kWeatherCardSun: true,
      kWeatherCardUltraviolet: true,
    };

    Map<String, bool> weatherSelectMap = {
      kWeatherCardTime: false,
      kWeatherCardWeek: false,
      kWeatherCardDust: false,
      kWeatherCardRain: false,
      kWeatherCardHumidity: false,
      kWeatherCardFeel: false,
      kWeatherCardWind: false,
      kWeatherCardSun: false,
      kWeatherCardUltraviolet: false,
    };

    if (idList.isNotEmpty) {
      for (var id in idList) {
        weatherInitMap[id] = false;
        weatherSelectMap[id] = true;
      }
    }

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
          child: SizedBox(
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title, Close Button
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: HeyText.title3Bold(
                          'bs_weather_title'.tr,
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
                // Selector
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(top: 16, bottom: 32, left: 20, right: 20),
                      child: Center(
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            // 시간대별 날씨
                            Visibility(
                              visible: weatherInitMap[kWeatherCardTime] ?? true,
                              child: HeyWeatherTimeCard(
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 주간 날씨
                            Visibility(
                              visible: weatherInitMap[kWeatherCardWeek] ?? true,
                              child: HeyWeatherWeekCard(
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 대기질
                            Visibility(
                              visible: weatherInitMap[kWeatherCardDust] ?? true,
                              child: HeyWeatherDustCard(
                                fine: '13',
                                fineState: '최고 좋음',
                                ultra: '10',
                                ultraState: '좋음',
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 강수
                            Visibility(
                              visible: weatherInitMap[kWeatherCardRain] ?? true,
                              child: HeyWeatherSmallCard(
                                id: kWeatherCardRain,
                                title: 'rain'.tr,
                                iconName: 'rain',
                                subtitle: '없음',
                                weatherState: '0',
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 습도
                            Visibility(
                              visible: weatherInitMap[kWeatherCardHumidity] ?? true,
                              child: HeyWeatherSmallCard(
                                id: kWeatherCardHumidity,
                                title: 'humidity'.tr,
                                iconName: 'humidity',
                                subtitle: '낮음',
                                weatherState: '16',
                                secondWeatherState: '17',
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 체감온도
                            Visibility(
                              visible: weatherInitMap[kWeatherCardFeel] ?? true,
                              child: HeyWeatherSmallCard(
                                id: kWeatherCardFeel,
                                title: 'feel_temp'.tr,
                                iconName: 'feel_temp',
                                weatherState: '30 28',
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 바람
                            Visibility(
                              visible: weatherInitMap[kWeatherCardWind] ?? true,
                              child: HeyWeatherSmallCard(
                                id: kWeatherCardWind,
                                title: 'wind'.tr,
                                iconName: 'wind',
                                subtitle: '없음',
                                weatherState:'3',
                                secondWeatherState: '북동',
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 일출 일몰
                            Visibility(
                              visible: weatherInitMap[kWeatherCardSun] ?? true,
                              child: HeyWeatherSunCard(
                                sunrise: sunrise,
                                sunset: sunset,
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                            // 자외선
                            Visibility(
                              visible: weatherInitMap[kWeatherCardUltraviolet] ?? true,
                              child: HeyWeatherUltravioletCard(
                                id: kWeatherCardUltraviolet,
                                ultraviolet: ultraviolet,
                                buttonStatus: 1,
                                onSelect: (id, selected) {
                                  weatherSelectMap[id] = selected;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Button
                Container(
                  margin: const EdgeInsets.all(20),
                  child: HeyElevatedButton.primaryText1(
                    text: 'confirm'.tr,
                    onPressed: () {
                      List<String> selectIds = weatherSelectMap.entries
                          .where((entry) => entry.value == true)
                          .map((entry) => entry.key)
                          .toList();
                      Get.back();
                      onConfirm?.call(selectIds);
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

  static void showSelectAddressBottomSheet(BuildContext context, {
    required List<Address> addressList,
    required currentAddress,
    Function? onSelectedAddress,
    Function? onMoveToAddress,
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
            constraints: const BoxConstraints(
              maxHeight: 392,
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
                      InkWell(
                        splashColor: kBaseColor,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
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
    required String searchText,
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

        final addressName = Utils().containsSearchText(address.addressName, searchText);

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
                            addressName,
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
                    InkWell(
                      splashColor: kBaseColor,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
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
                      onCreateAddress.call(address, searchText);
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

  static void showTemperatureBottomSheet(BuildContext context, {
    required isFahrenheit,
    Function? onSelected,
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
            constraints: const BoxConstraints(
              maxHeight: 210,
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
                          'setting_temperature'.tr,
                          fontSize: kFont18,
                          color: kTextPointColor,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        splashColor: kBaseColor,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Get.back();
                        },
                        child: SvgUtils.icon(context, 'close', width: 32, height: 32),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 섭씨
                        InkWell(
                          splashColor: kBaseColor,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            Get.back();
                            onSelected?.call(false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                HeyText.body(
                                  '${'celsius'.tr} ${'celsius_text'.tr}',
                                  color: !isFahrenheit ? kPrimaryDarkerColor : kTextPrimaryColor,
                                ),
                                const SizedBox(width: 12),
                                Visibility(
                                  visible: !isFahrenheit,
                                  child: SvgUtils.icon(
                                    context,
                                    'check_outline',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 화씨
                        InkWell(
                          splashColor: kBaseColor,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            Get.back();
                            onSelected?.call(true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 54, left: 24, right: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                HeyText.body(
                                  '${'fahrenheit'.tr} ${'fahrenheit_text'.tr}',
                                  color: isFahrenheit ? kPrimaryDarkerColor : kTextPrimaryColor,
                                ),
                                const SizedBox(width: 12),
                                Visibility(
                                  visible: isFahrenheit,
                                  child: SvgUtils.icon(
                                    context,
                                    'check_outline',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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