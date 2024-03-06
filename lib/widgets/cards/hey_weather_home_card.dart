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
    this.iconName = '',
    this.weatherStatus = '',
    this.temperature = 0,
    this.yesterdayTemperature = 0,
    this.rain = 0,
    this.rainPercent = 0,
    this.rainTime = '',
    this.fineDust = 0,
    this.ultraFineDust = 0,
  });

  final String iconName;
  final String weatherStatus;
  final int temperature;
  final int yesterdayTemperature;
  final int rain;
  final int rainPercent;
  final String rainTime;
  final int fineDust;
  final int ultraFineDust;

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
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tag
          HeyCustomButton.outlineTag(
            text: HeyText.footnoteSemiBold(
              weatherStatus,
              color: kTextSecondaryColor,
            ),
          ),

          // Temp, Icon
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                HeyText.bodySemiBold(
                  '${isFahrenheit.value ? Utils.celsiusToFahrenheit(temperature.toDouble()) : temperature}°',
                  fontSize: kFont73,
                ),
                const Spacer(),
                Visibility(
                  visible: iconName.isNotEmpty == true,
                  child: ImageUtils(
                    iconName: iconName,
                    width: 136,
                    height: 120,
                  ),
                ),
              ],
            ),
          ),

          // Message
          Column(
            children: [
              HeyCustomButton.tagWithIcon(
                context,
                iconName: 'card_temperature',
                text: temperature == yesterdayTemperature
                    ? 'home_card_message_3'.tr
                    : temperature > yesterdayTemperature
                    ? 'home_card_message_2'.trParams({'count': '${temperature - yesterdayTemperature}'})
                    : 'home_card_message_1'.trParams({'count': '${yesterdayTemperature - temperature}'}),
              ),
              const SizedBox(height: 16),
              HeyCustomButton.tagWithIcon(
                context,
                iconName: 'card_rain',
                text: rain == 0 && rainTime.isNotEmpty
                    ? 'home_card_message_4'.trParams({'time':rainTime, 'percent':'$rainPercent'})
                    : rain == 0 && rainTime.isEmpty
                    ? 'home_card_message_5'.tr
                    : rain < 3
                    ? 'home_card_message_6'.trParams({'status': weatherStatus})
                    : rain >= 3 && rain < 8
                    ? 'home_card_message_7'.trParams({'status': weatherStatus})
                    : rain >= 8 && rain < 12
                    ? 'home_card_message_8'.trParams({'status': weatherStatus})
                    : rain >= 12 && rain < 20
                    ? 'home_card_message_9'.trParams({'status': weatherStatus})
                    : 'home_card_message_10'.trParams({'status': weatherStatus}),
              ),
              //ultraFineDust > 50 && ultraFineDust <= 100 ? ultraFineDust > 100
              const SizedBox(height: 16),
              HeyCustomButton.tagWithIcon(
                context,
                iconName: 'card_cloudy',
                text: fineDust < 30
                    ? 'home_card_message_11'.tr
                    : fineDust > 30 && fineDust <= 80
                    ? 'home_card_message_12'.tr
                    : ultraFineDust > 50 && ultraFineDust <= 100
                    ? 'home_card_message_15'.tr
                    : ultraFineDust > 100
                    ? 'home_card_message_16'.tr
                    : fineDust > 80 && fineDust <= 150
                    ? 'home_card_message_13'.tr
                    : 'home_card_message_14'.tr,
              ),
            ],
          ),
        ],
      ),
    );
  }
}