import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';

class HeyWeatherSelectCard extends StatefulWidget {
  const HeyWeatherSelectCard({
    super.key,
    required this.title,
    required this.iconName,
  });

  final String title;
  final String iconName;

  @override
  State<HeyWeatherSelectCard> createState() => _HeyWeatherSelectCardState();
}

class _HeyWeatherSelectCardState extends State<HeyWeatherSelectCard> {
  final isSelected = false.obs;

  // Colors
  final Map<String, Color> stateColors = {
    'none'.tr : kIconColor,
    'low'.tr : kPrimaryDarkerColor,
    'good'.tr : kPrimaryDarkerColor,
    'weak'.tr : kPrimaryDarkerColor,
    'high'.tr : kSubColor,
    'normal'.tr : kHeyGreenColor,
    'bad'.tr : kHeyOrangeColor,
    'very_high'.tr: kHeyOrangeColor,
    'strong'.tr: kHeyRedColor,
    'danger'.tr: kHeyRedColor,
    'very_bad'.tr: kHeyRedColor,
    'very_good'.tr: kHeySkyBlueColor,
  };

  // Colors
  final Map<String, String> stateUnits = {
    'humidity'.tr : '%',
    'wind'.tr : 'm/s',
    'rain'.tr : 'mm',
    'fine_dust'.tr : '㎍/m³',
    'ultra_fine_dust'.tr : '㎍/m³',
    'wind_chill'.tr: '˚',
  };

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width / 2) - 22;

    return Obx(() => GestureDetector(
      onTap: () {
        isSelected(isSelected.value != true);
      },
      child: Container(
        width: width,

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: kBaseColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected.value ? kPrimaryDarkerColor : kBaseColor,
            width: 1, // 외곽선 두께
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageUtils.icon(
              context,
              widget.iconName,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 6),
            HeyText.bodySemiBold(
              widget.title,
              fontSize: kFont13,
              color: kTextDisabledColor,
            ),
            const Spacer(),
            Visibility(
              visible: isSelected.value,
              child: ImageUtils.icon(
                context,
                'check_outline',
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}