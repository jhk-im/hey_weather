import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_land.dart';
import 'package:hey_weather/repository/soruce/remote/model/mid_term_temperature.dart';
import 'package:intl/intl.dart';

class HeyWeatherWeekCard extends StatefulWidget {
  const HeyWeatherWeekCard({
    super.key,
    required this.midTermLand,
    required this.midTermTemperature,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });
  final MidTermLand midTermLand;
  final MidTermTemperature midTermTemperature;
  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherWeekCard> createState() => _HeyWeatherWeekCardState();
}

class _HeyWeatherWeekCardState extends State<HeyWeatherWeekCard> {
  final id = kWeatherCardWeek;
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 432;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, height);

    var todayMaxTemperature = SharedPreferencesUtil().getInt(kTodayMaxTemperature);
    var todayMinTemperature = SharedPreferencesUtil().getInt(kTodayMinTemperature);
    var todayAmRainPercentage = SharedPreferencesUtil().getInt(kTodayAmRainPercentage);
    var todayPmRainPercentage = SharedPreferencesUtil().getInt(kTodayPmRainPercentage);
    var todayAmStatus = SharedPreferencesUtil().getInt(kTodayAmStatus);
    var todayPmStatus = SharedPreferencesUtil().getInt(kTodayPmStatus);

    var tomorrowMaxTemperature = SharedPreferencesUtil().getInt(kTomorrowMaxTemperature);
    var tomorrowMinTemperature = SharedPreferencesUtil().getInt(kTomorrowMinTemperature);
    var tomorrowAmRainPercentage = SharedPreferencesUtil().getInt(kTomorrowAmRainPercentage);
    var tomorrowPmRainPercentage = SharedPreferencesUtil().getInt(kTomorrowPmRainPercentage);
    var tomorrowAmStatus = SharedPreferencesUtil().getInt(kTomorrowAmStatus);
    var tomorrowPmStatus = SharedPreferencesUtil().getInt(kTomorrowPmStatus);

    int getIconIndex(String status) {
      int result = 0;
      if (!status.contains('비') && !status.contains('빗') && !status.contains('소')) {
        if (status.contains('눈')) {
          result = 1;
        } else if (status.contains('맑음')) {
          result = 2;
        } else if (status.contains('구름많음')) {
          result = 3;
        } else if (status.contains('흐림')) {
          result = 4;
        }
      }
      return result;
    }

    DateTime today = DateTime.now();
    DateFormat formatter = DateFormat('E MM.dd', 'ko_KR');
    List<String> weekList = [];
    List<String> dateList = [];
    for (int i = 0; i <= 6; i++) {
      DateTime nextDate = today.add(Duration(days: i));
      String formattedDate = formatter.format(nextDate);
      List<String> format = formattedDate.split(' ');
      if (i == 0) {
        weekList.add('오늘');
      } else if (i == 1) {
        weekList.add('내일');
      } else {
        weekList.add(format[0]);
      }
      dateList.add(format[1]);
    }

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
          height: height,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // icon, title
                    Row(
                      children: [
                        SvgUtils.icon(
                          context,
                          'weather_week',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        HeyText.bodySemiBold(
                          'weather_week'.tr,
                          fontSize: kFont16,
                          color: kTextDisabledColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _weatherItem(
                            dateText: '',
                            dateText2: dateList[0],
                            amPercent: todayAmRainPercentage,
                            pmPercent: todayPmRainPercentage,
                            amIconName: '${kWeatherWeekIconList[todayAmStatus]}_on',
                            pmIconName: '${kWeatherWeekIconList[todayPmStatus]}_on',
                            minTemp: todayMaxTemperature,
                            maxTemp: todayMinTemperature,
                          ),
                      
                          _weatherItem(
                            dateText: weekList[1],
                            dateText2: dateList[1],
                            amPercent: tomorrowAmRainPercentage,
                            pmPercent: tomorrowPmRainPercentage,
                            amIconName: '${kWeatherWeekIconList[tomorrowAmStatus]}_on',
                            pmIconName: '${kWeatherWeekIconList[tomorrowPmStatus]}_on',
                            minTemp: tomorrowMaxTemperature,
                            maxTemp: tomorrowMinTemperature,
                          ),
                      
                          _weatherItem(
                            dateText: weekList[2],
                            dateText2: dateList[2],
                            amPercent: widget.midTermLand.rnSt3Am ?? 0,
                            pmPercent: widget.midTermLand.rnSt3Pm ?? 0,
                            amIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf3Am ?? '')]}_on',
                            pmIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf3Pm ?? '')]}_on',
                            minTemp: widget.midTermTemperature.taMax3 ?? 0,
                            maxTemp: widget.midTermTemperature.taMin3 ?? 0,
                          ),
                      
                          _weatherItem(
                            dateText: weekList[3],
                            dateText2: dateList[3],
                            amPercent: widget.midTermLand.rnSt4Am ?? 0,
                            pmPercent: widget.midTermLand.rnSt4Pm ?? 0,
                            amIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf4Am ?? '')]}_on',
                            pmIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf4Pm ?? '')]}_on',
                            minTemp: widget.midTermTemperature.taMax4 ?? 0,
                            maxTemp: widget.midTermTemperature.taMin4 ?? 0,
                          ),
                      
                          _weatherItem(
                            dateText: weekList[4],
                            dateText2: dateList[4],
                            amPercent: widget.midTermLand.rnSt5Am ?? 0,
                            pmPercent: widget.midTermLand.rnSt5Pm ?? 0,
                            amIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf5Am ?? '')]}_on',
                            pmIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf5Pm ?? '')]}_on',
                            minTemp: widget.midTermTemperature.taMax5 ?? 0,
                            maxTemp: widget.midTermTemperature.taMin5 ?? 0,
                          ),
                      
                          _weatherItem(
                            dateText: weekList[5],
                            dateText2: dateList[5],
                            amPercent: widget.midTermLand.rnSt6Am ?? 0,
                            pmPercent: widget.midTermLand.rnSt6Pm ?? 0,
                            amIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf6Am ?? '')]}_on',
                            pmIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf6Pm ?? '')]}_on',
                            minTemp: widget.midTermTemperature.taMax6 ?? 0,
                            maxTemp: widget.midTermTemperature.taMin6 ?? 0,
                          ),
                      
                          _weatherItem(
                            dateText: weekList[6],
                            dateText2: dateList[6],
                            amPercent: widget.midTermLand.rnSt7Am ?? 0,
                            pmPercent: widget.midTermLand.rnSt7Pm ?? 0,
                            amIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf7Am ?? '')]}_on',
                            pmIconName: '${kWeatherWeekIconList[getIconIndex(widget.midTermLand.wf7Pm ?? '')]}_on',
                            minTemp: widget.midTermTemperature.taMax7 ?? 0,
                            maxTemp: widget.midTermTemperature.taMin7 ?? 0,
                          ),
                        ],
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

  Widget _weatherItem({
    String dateText = '',
    String dateText2 = '',
    int amPercent = 0,
    int pmPercent = 0,
    String amIconName = '',
    String pmIconName = '',
    int minTemp = 0,
    int maxTemp = 0,
  }) {
    return SizedBox(
      width: double.maxFinite,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              HeyText.callOutSemiBold(
                dateText.isEmpty ? 'today'.tr : dateText,
                color: dateText.isEmpty ? kTextPointColor : kTextDisabledColor,
              ),
              HeyText.caption1(
                dateText2,
                color: kTextPointColor.withOpacity(0.3),
              ),
            ],
          ),

          const Spacer(flex: 4),

          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: dateText.isEmpty,
                    child: HeyText.caption1(
                      'am'.tr,
                      color: kTextDisabledColor,
                    ),
                  ),
                  HeyText.caption1(
                    '$amPercent%',
                    color: amPercent > 0 ? kPrimarySecondColor : kDisabledText,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              SvgUtils.weatherIcon(
                context,
                amIconName,
                width: 34,
                height: 34,
              ),
              const SizedBox(width: 8),
              SvgUtils.weatherIcon(
                context,
                pmIconName,
                width: 34,
                height: 34,
              ),
              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: dateText.isEmpty,
                    child: HeyText.caption1(
                      'pm'.tr,
                      color: kTextDisabledColor,
                    ),
                  ),
                  HeyText.caption1(
                    '$pmPercent%',
                    color: pmPercent > 0 ? kPrimarySecondColor : kDisabledText,
                  ),
                ],
              ),
            ],
          ),

          const Spacer(flex: 3),

          SizedBox(
            child: Row(
              children: [
                const SizedBox(width: 16),
                HeyText.bodySemiBold(
                  '$minTemp˚',
                  fontSize: kFont16,
                  color: kTextPointColor.withOpacity(0.6),
                ),
                const SizedBox(width: 16),
                HeyText.bodySemiBold(
                  '$maxTemp˚',
                  fontSize: kFont16,
                  color: kTextPointColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}