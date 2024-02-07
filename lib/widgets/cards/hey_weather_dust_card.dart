import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherDustCard extends StatefulWidget {
  const HeyWeatherDustCard({
    super.key,
    required this.fine,
    required this.fineState,
    required this.ultra,
    required this.ultraState,
  });

  final String fine;
  final String fineState;
  final String ultra;
  final String ultraState;

  @override
  State<HeyWeatherDustCard> createState() => _HeyWeatherDustCardState();
}

class _HeyWeatherDustCardState extends State<HeyWeatherDustCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select

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

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    return Obx(() => GestureDetector(
      onTap: () {
        if (status.value == 2) {
          status.value = 0;
        } else {
          status.value += 1;
        }
      },
      child: Container(
        width: width,
        height: width / 2.2,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kBaseColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: status.value == 2 ? kPrimaryDarkerColor : kBaseColor,
            width: 1, // 외곽선 두께
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  // icon, title
                  Row(
                    children: [
                      SvgUtils.icon(
                        context,
                        'dust',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 6),
                      HeyText.bodySemiBold(
                        'dust'.tr,
                        fontSize: kFont16,
                        color: kTextDisabledColor,
                      ),
                    ],
                  ),

                  const Spacer(),
                  Row(
                    children: [
                      // 미세먼지
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                HeyText.bodySemiBold(
                                  'dust_fine'.tr,
                                  fontSize: kFont15,
                                  color: kTextDisabledColor,
                                ),
                                const SizedBox(width: 8),
                                HeyText.bodySemiBold(
                                  widget.fineState,
                                  fontSize: kFont15,
                                  color: stateColors[widget.fineState] ?? kTextPointColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                HeyText.largeTitleBold(
                                  widget.fine,
                                  color: kTextPointColor,
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: HeyText.bodySemiBold(
                                    '㎍/m³',
                                    fontSize: kFont20,
                                    color: kIconColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 1,
                        color: kDividerPrimaryColor,
                      ),
                      // 초미세먼지
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  HeyText.bodySemiBold(
                                    'dust_ultra'.tr,
                                    fontSize: kFont15,
                                    color: kTextDisabledColor,
                                  ),
                                  const SizedBox(width: 8),
                                  HeyText.bodySemiBold(
                                    widget.ultraState,
                                    fontSize: kFont15,
                                    color: stateColors[widget.ultraState] ?? kTextPointColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  HeyText.largeTitleBold(
                                    widget.ultra,
                                    color: kTextPointColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: HeyText.bodySemiBold(
                                      '㎍/m³',
                                      fontSize: kFont20,
                                      color: kIconColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Visibility(
              visible: status.value > 0,
              child: Container(
                color: status.value == 1 ? Colors.transparent : kBaseColor.withOpacity(0.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        SvgUtils.icon(
                          context,
                          status.value == 1
                              ? 'circle_check'
                              : 'circle_check_selected',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}