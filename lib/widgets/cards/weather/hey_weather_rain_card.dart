import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherRainCard extends StatefulWidget {
  const HeyWeatherRainCard({
    super.key,
    this.rain = 0,
    this.rainStatus = '없음',
    this.percentage = 0,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final int rain;
  final String rainStatus;
  final int percentage;
  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherRainCard> createState() => _HeyWeatherRainCardState();
}

class _HeyWeatherRainCardState extends State<HeyWeatherRainCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  // Colors
  /*final Map<String, String> stateUnits = {
    'humidity'.tr : '%',
    'wind'.tr : 'm/s',
    'rain'.tr : 'mm',
    'fine_dust'.tr : '㎍/m³',
    'ultra_fine_dust'.tr : '㎍/m³',
    'feel_temp'.tr: '˚',
  };*/

  @override
  Widget build(BuildContext context) {
    String id = kWeatherCardRain;
    double width = (MediaQuery.of(context).size.width / 2) - 28;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, width);

    return Obx(() => Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: status.value == 1 || status.value == 2 ? () {
          if (status.value == 1) {
            status(2);
          } else {
            status(1);
          }
          widget.onSelect?.call(id, status.value == 2);
        } : null,
        child: Container(
          width: width,
          height: width,
          constraints: const BoxConstraints(minHeight: 162),
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
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // icon, title
                            Row(
                              children: [
                                SvgUtils.icon(
                                  context,
                                  'rain',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 6),
                                HeyText.bodySemiBold(
                                  'rain'.tr,
                                  fontSize: kFont16,
                                  color: kTextDisabledColor,
                                ),
                              ],
                            ),
                            const Spacer(),
                            // status
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: HeyText.subHeadlineSemiBold(
                                widget.rainStatus,
                                color: widget.rainStatus == '없음' ? kIconColor : kTextPointColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                HeyText.largeTitleBold(
                                  widget.rain.toString(),
                                  color: kTextPointColor,
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: HeyText.bodySemiBold(
                                    'mm',
                                    color: kTextDisabledColor,
                                    fontSize: kFont20,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            Row(
                              children: [
                                HeyText.footnote(
                                  /*widget.secondWeatherState.isNotEmpty
                                      ? '${widget.secondWeatherState} ${'within'.tr}'
                                      : 'no_forecast'.tr,
                                  color: widget.secondWeatherState.isNotEmpty ? kPrimaryDarkerColor : kIconColor,*/
                                  widget.percentage == 0
                                      ? 'no_forecast'.tr
                                      : '${widget.percentage}%',
                                  color: widget.percentage == 0 ? kIconColor : kPrimaryDarkerColor,
                                ),
                                const SizedBox(width: 4),
                                Visibility(
                                  visible: widget.percentage == 0,
                                  child: SvgUtils.icon(
                                    context,
                                    'direction',
                                    width: 10,
                                    height: 10,
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
                ),
              ),

              Visibility(
                visible: status.value > 0,
                child: Container(
                  color: status.value == 1 || status.value == 3 ? Colors.transparent : kBaseColor.withOpacity(0.5),
                  child: Column(
                    children: [
                      InkWell(
                        splashColor: kBaseColor,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: status.value == 3 ? () {
                          widget.onRemove?.call(id);
                        } : null,
                        child: Row(
                          children: [
                            const Spacer(),
                            SvgUtils.icon(
                              context,
                              status.value == 1
                                  ? 'circle_check'
                                  : status.value == 2
                                  ? 'circle_check_selected'
                                  : 'circle_minus',
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}