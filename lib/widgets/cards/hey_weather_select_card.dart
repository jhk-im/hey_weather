import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherSelectCard extends StatefulWidget {
  const HeyWeatherSelectCard({
    super.key,
    required this.id,
    required this.title,
    required this.iconName,
    this.onSelect,
  });

  final String id;
  final String title;
  final String iconName;
  final Function? onSelect;

  @override
  State<HeyWeatherSelectCard> createState() => _HeyWeatherSelectCardState();
}

class _HeyWeatherSelectCardState extends State<HeyWeatherSelectCard> {
  final isSelected = false.obs;

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width / 2) - 22;

    return Obx(() => GestureDetector(
          onTap: () {
            isSelected(isSelected.value != true);
            widget.onSelect?.call(widget.id, isSelected.value);
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
                SvgUtils.icon(
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
        ));
  }
}
