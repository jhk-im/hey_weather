import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_land.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_temperature.dart';
import 'package:hey_weather/repository/soruce/remote/model/short_term.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/buttons/hey_weather_address_button.dart';
import 'package:hey_weather/widgets/cards/hey_weather_home_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_select_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_dust_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_humidity_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_rain_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_chill_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_sun_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_time_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_ultraviolet_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_week_card.dart';
import 'package:hey_weather/widgets/cards/weather/hey_weather_wind_card.dart';

import 'svg_utils.dart';

class HeyBottomSheet {
  static void showOnBoardingBottomSheet(BuildContext context,
      {Function? onAdd}) {
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
                        child: SvgUtils.icon(context, 'close',
                            width: 32, height: 32),
                      ),
                    ],
                  ),
                ),
                // Subtitle
                Container(
                  margin: const EdgeInsets.only(
                      top: 12, bottom: 16, left: 20, right: 20),
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

  static void showAddWeatherBottomSheet(
    BuildContext context,
    List<String> idList, {
    Function? onConfirm,
    List<ShortTerm>? timeTemperatureList,
    List<ShortTerm>? timeSkyStatusList,
    List<ShortTerm>? timeRainStatusList,
    List<ShortTerm>? timeRainPercentList,
    String timeSunrise = '',
    String timeSunset = '',
    int timeCurrentTemperature = 0,
    MidTermLand? weekMidTermLand,
    MidTermTemperature? weekMidTermTemperature,
    int dustFine = 0,
    int dustUltraFine = 0,
    double rain = 0.0,
    String rainStatus = '',
    int rainPercentage = 0,
    int humidity = 0,
    int feelMax = 0,
    int feelMin = 0,
    double windSpeed = 0.0,
    int windDirection = 0,
    int sunriseTime = 0,
    int sunsetTime = 0,
    int ultraviolet = 0,
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

    var weatherIdList = [
      kWeatherCardTime,
      kWeatherCardWeek,
      kWeatherCardDust,
      kWeatherCardRain,
      kWeatherCardHumidity,
      kWeatherCardFeel,
      kWeatherCardWind,
      kWeatherCardSun,
      kWeatherCardUltraviolet,
      'empty'
    ];

    if (idList.isNotEmpty) {
      for (var id in idList) {
        if (id != 'empty') {
          weatherInitMap[id] = false;
          weatherSelectMap[id] = true;
          weatherIdList.remove(id);
        }
      }
    }

    Widget weatherWidgets(String id) {
      switch (id) {
        case kWeatherCardTime:
          return HeyWeatherTimeCard(
            temperatureList: timeTemperatureList ?? [],
            skyStatusList: timeSkyStatusList ?? [],
            rainStatusList: timeRainStatusList ?? [],
            rainPercentList: timeRainPercentList ?? [],
            sunset: sunsetTime,
            sunrise: sunriseTime,
            currentTemperature: timeCurrentTemperature,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardWeek:
          return HeyWeatherWeekCard(
            midTermLand: weekMidTermLand ?? MidTermLand(),
            midTermTemperature: weekMidTermTemperature ?? MidTermTemperature(),
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardDust:
          return HeyWeatherDustCard(
            fine: dustFine,
            ultra: dustUltraFine,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardRain:
          return HeyWeatherRainCard(
            rain: rain,
            rainStatus: rainStatus,
            percentage: rainPercentage,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardHumidity:
          return HeyWeatherHumidityCard(
            today: humidity,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardFeel:
          return HeyWeatherFeelCard(
            max: feelMax,
            min: feelMin,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardWind:
          return HeyWeatherWindCard(
            speed: windSpeed,
            direction: windDirection,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardSun:
          return HeyWeatherSunCard(
            sunrise: timeSunrise,
            sunset: timeSunset,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        case kWeatherCardUltraviolet:
          return HeyWeatherUltravioletCard(
            ultraviolet: ultraviolet,
            buttonStatus: 1,
            onSelect: (id, selected) {
              weatherSelectMap[id] = selected;
            },
          );
        default:
          return Container();
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
                        child: SvgUtils.icon(context, 'close',
                            width: 32, height: 32),
                      ),
                    ],
                  ),
                ),
                // Selector
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 32, left: 20, right: 20),
                      child: Center(
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children:
                              List.generate(weatherIdList.length, (index) {
                            return weatherWidgets(weatherIdList[index]);
                          }),
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

  static void showSelectAddressBottomSheet(
    BuildContext context, {
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
                        child: SvgUtils.icon(context, 'close',
                            width: 32, height: 32),
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
                        for (var address in addressList) ...{
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

  static void showCreateAddressBottomSheet(
    BuildContext context, {
    required Address address,
    required String searchText,
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
        // final addressName = Utils().containsSearchText(address.addressName, searchText);

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
                            searchText,
                            fontSize: kFont18,
                            color: kPrimaryDarkerColor,
                          ),
                          HeyText.title3Bold(
                            Utils.hasKoreanFinalConsonant(
                                    address.addressName ?? '')
                                ? 'question_add_1'.tr
                                : 'question_add_2'.tr,
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
                      child: SvgUtils.icon(context, 'close',
                          width: 32, height: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Card
                HeyWeatherHomeCard(
                  homeWeatherStatusText: address.weatherStatusText ?? '',
                  homeWeatherIconName: address.weatherIconName ?? '',
                  homeTemperature: address.temperature ?? 0,
                  homeYesterdayTemperature: address.yesterdayTemperature ?? 0,
                  homeRain: address.rain ?? 0,
                  homeRainTimeText: address.rainTimeText ?? '',
                  homeRainPercent: address.rainPercent ?? 0,
                  homeFineDust: address.fineDust ?? 0,
                  homeUltraFineDust: address.ultraFineDust ?? 0,
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

  static void showTemperatureBottomSheet(
    BuildContext context, {
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
                        child: SvgUtils.icon(context, 'close',
                            width: 32, height: 32),
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
                            padding: const EdgeInsets.only(
                                bottom: 30, left: 24, right: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                HeyText.body(
                                  '${'celsius'.tr} ${'celsius_text'.tr}',
                                  color: !isFahrenheit
                                      ? kPrimaryDarkerColor
                                      : kTextPrimaryColor,
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
                            padding: const EdgeInsets.only(
                                bottom: 54, left: 24, right: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                HeyText.body(
                                  '${'fahrenheit'.tr} ${'fahrenheit_text'.tr}',
                                  color: isFahrenheit
                                      ? kPrimaryDarkerColor
                                      : kTextPrimaryColor,
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
