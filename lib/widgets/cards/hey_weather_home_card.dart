import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/widgets/buttons/hey_custom_button.dart';

class HeyWeatherHomeCard extends StatelessWidget {
  const HeyWeatherHomeCard({
    super.key,
    this.homeWeatherStatusText = '',
    this.homeWeatherIconName = '',
    this.homeTemperature = 0,
    this.homeYesterdayTemperature = 0,
    this.homeRain = 0,
    this.homeRainPercent = 0,
    this.homeRainTimeText = '',
    this.homeFineDust = 0,
    this.homeUltraFineDust = 0,
    this.isSkeleton = false,
  });

  final String homeWeatherStatusText;
  final String homeWeatherIconName;

  final int homeTemperature;
  final int homeYesterdayTemperature;

  final int homeRain;
  final int homeRainPercent;
  final String homeRainTimeText;

  final int homeFineDust;
  final int homeUltraFineDust;

  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    final isFahrenheit = false.obs;
    isFahrenheit(SharedPreferencesUtil().getBool(kFahrenheit));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kBaseColor,
      ),
      child: isSkeleton ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tag
          Container(
            width: 68,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kButtonColor,
            ),
          ),

          // Temperature, Icon
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: double.maxFinite,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kButtonColor,
            ),
          ),

          // Message
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: double.maxFinite,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kButtonColor,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: double.maxFinite,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kButtonColor,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: double.maxFinite,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kButtonColor,
            ),
          ),
        ],
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tag
          HeyCustomButton.outlineTag(
            text: HeyText.footnoteSemiBold(
              homeWeatherStatusText,
              color: kTextSecondaryColor,
            ),
          ),

          // Temperature, Icon
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                HeyText.bodySemiBold(
                  '${isFahrenheit.value ? Utils.celsiusToFahrenheit(homeTemperature.toDouble()) : homeTemperature}°',
                  fontSize: kFont73,
                ),
                const Spacer(),
                Visibility(
                  visible: homeWeatherIconName.isNotEmpty == true,
                  child: ImageUtils(
                    iconName: homeWeatherIconName,
                    width: 136,
                    height: 120,
                  ),
                ),
              ],
            ),
          ),

          // Message
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  HeyCustomButton.tagWithIcon(
                    context,
                    iconName: 'card_temperature',
                    text: homeTemperature == homeYesterdayTemperature
                        ? 'home_card_message_3'.tr
                        : homeTemperature > homeYesterdayTemperature
                        ? 'home_card_message_2'.trParams({'count': '${homeTemperature - homeYesterdayTemperature}'})
                        : 'home_card_message_1'.trParams({'count': '${homeYesterdayTemperature - homeTemperature}'}),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  HeyCustomButton.tagWithIcon(
                    context,
                    iconName: 'card_rain',
                    text: homeRain == 0 && homeRainTimeText.isNotEmpty && homeRainPercent > 50
                        ? 'home_card_message_4'.trParams({'time':homeRainTimeText, 'percent':'$homeRainPercent'})
                        : homeRain == 0
                        ? 'home_card_message_5'.tr
                        : homeRain > 0 && homeRain < 3
                        ? 'home_card_message_6'.trParams({'status': homeWeatherStatusText})
                        : homeRain >= 3 && homeRain < 8
                        ? 'home_card_message_7'.trParams({'status': homeWeatherStatusText})
                        : homeRain >= 8 && homeRain < 12
                        ? 'home_card_message_8'.trParams({'status': homeWeatherStatusText})
                        : homeRain >= 12 && homeRain < 20
                        ? 'home_card_message_9'.trParams({'status': homeWeatherStatusText})
                        : 'home_card_message_10'.trParams({'status': homeWeatherStatusText}),
                  ),
                  const Spacer(),
                ],
              ),
              //ultraFineDust > 50 && ultraFineDust <= 100 ? ultraFineDust > 100
              const SizedBox(height: 16),
              Row(
                children: [
                  HeyCustomButton.tagWithIcon(
                    context,
                    iconName: 'card_cloudy',
                    text: homeFineDust <= 30
                        ? 'home_card_message_11'.tr
                        : homeFineDust > 30 && homeFineDust <= 80
                        ? 'home_card_message_12'.tr
                        : homeFineDust > 80 && homeFineDust <= 150 && homeUltraFineDust <= 50
                        ? 'home_card_message_13'.tr
                        : homeFineDust > 150 && homeUltraFineDust <= 50
                        ? 'home_card_message_14'.tr
                        : homeUltraFineDust > 50 && homeUltraFineDust <= 100
                        ? 'home_card_message_15'.tr
                        : 'home_card_message_16'.tr
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}