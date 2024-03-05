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
    this.weatherStatus,
    this.temperature,
    this.message1,
    this.message2,
    this.message3,
  });

  final String iconName;
  final String? weatherStatus;
  final String? temperature;
  final String? message1;
  final String? message2;
  final String? message3;

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
              weatherStatus ?? '',
              color: kTextSecondaryColor,
            ),
          ),

          // Temp, Icon
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                HeyText.bodySemiBold(
                  '${isFahrenheit.value ? Utils.celsiusToFahrenheit(double.parse(temperature ?? '0')) : temperature}°',
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
                text: message1 ?? '',
              ),
              const SizedBox(height: 16),
              HeyCustomButton.tagWithIcon(
                context,
                iconName: 'card_rain',
                text: message2 ?? '',
              ),
              const SizedBox(height: 16),
              HeyCustomButton.tagWithIcon(
                context,
                iconName: 'card_cloudy',
                text: message3 ?? '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}