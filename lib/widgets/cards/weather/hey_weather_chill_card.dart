import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';

class HeyWeatherFeelCard extends StatefulWidget {
  const HeyWeatherFeelCard({
    super.key,
    this.max = 0,
    this.min = 0,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final int max;
  final int min;
  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherFeelCard> createState() => _HeyWeatherFeelCardState();
}

class _HeyWeatherFeelCardState extends State<HeyWeatherFeelCard> {
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  @override
  Widget build(BuildContext context) {
    String id = kWeatherCardFeel;
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
                    // 체감온도
                    Row(
                      children: [
                        SvgUtils.icon(
                          context,
                          'feel_temp',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        HeyText.bodySemiBold(
                          'feel_temp'.tr,
                          fontSize: kFont16,
                          color: kTextDisabledColor,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            HeyText.bodySemiBold(
                              'highest'.tr,
                              color: kTextPointColor,
                            ),
                            SvgUtils.icon(
                              context,
                              'highest',
                              width: 24,
                              height: 24,
                            ),
                            HeyText.largeTitleBold(
                              '${widget.max}˚',
                              color: kTextPointColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            HeyText.bodySemiBold(
                              'lowest'.tr,
                              color: kTextPointColor,
                            ),
                            SvgUtils.icon(
                              context,
                              'lowest',
                              width: 24,
                              height: 24,
                            ),
                            HeyText.largeTitleBold(
                              '${widget.min}˚',
                              color: kTextPointColor,
                            ),
                          ],
                        ),
                      ],
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