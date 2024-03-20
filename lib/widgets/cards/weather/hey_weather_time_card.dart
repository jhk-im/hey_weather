import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/shared_preferences_util.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/common/utils.dart';
import 'package:hey_weather/repository/soruce/remote/model/short_term.dart';

class HeyWeatherTimeCard extends StatefulWidget {
  const HeyWeatherTimeCard({
    super.key,
    required this.temperatureList,
    required this.skyStatusList,
    required this.rainStatusList,
    required this.rainPercentList,
    this.sunset = 500,
    this.sunrise = 1900,
    this.currentTemperature = 0,
    this.buttonStatus = 0,
    this.setHeight,
    this.onSelect,
    this.onRemove,
  });

  final List<ShortTerm> skyStatusList;
  final List<ShortTerm> temperatureList;
  final List<ShortTerm> rainStatusList;
  final List<ShortTerm> rainPercentList;
  final int sunset;
  final int sunrise;
  final int currentTemperature;
  final int buttonStatus;
  final Function? setHeight;
  final Function? onSelect;
  final Function? onRemove;

  @override
  State<HeyWeatherTimeCard> createState() => _HeyWeatherTimeCardState();
}

class _HeyWeatherTimeCardState extends State<HeyWeatherTimeCard> {
  final id = kWeatherCardTime;
  final status = 0.obs; // 0 -> default, 1 -> edit, 2 -> select, 3 -> delete
  final isFahrenheit = false.obs;

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width) - 28;
    double height = 286;
    status(widget.buttonStatus);
    widget.setHeight?.call(id, height);

    int maxTemperatureValue = SharedPreferencesUtil().getInt(kTodayMaxTemperature);
    int minTemperatureValue = SharedPreferencesUtil().getInt(kTodayMinTemperature);

    isFahrenheit(SharedPreferencesUtil().getBool(kFahrenheit));

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
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: kBaseColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: status.value == 2 ? kPrimaryDarkerColor : kBaseColor,
              width: 1, // 외곽선 두께
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // icon, title
                  Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: Row(
                      children: [
                        SvgUtils.icon(
                          context,
                          'weather_by_time',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 6),
                        HeyText.bodySemiBold(
                          'weather_by_time'.tr,
                          fontSize: kFont16,
                          color: kTextDisabledColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.skyStatusList.length,
                      itemBuilder: (context, index) {
                        String temperature = '';

                        String time = widget.temperatureList[index].fcstTime ?? '0000';
                        int currentTime = int.parse(time);
                        String timeText = '';
                        if (index > 0) {
                          temperature = widget.temperatureList[index].fcstValue ?? '';
                          timeText = Utils.convertToTimeFormat(time);
                        } else {
                          temperature = widget.currentTemperature.toString();
                        }

                        int rainPercent = int.parse(widget.rainPercentList[index].fcstValue ?? '0');
                        int rainIndex = int.parse(widget.rainStatusList[index].fcstValue ?? '0');
                        String rainStatus = widget.rainStatusList[index].weatherCategory?.codeValues?[rainIndex] ?? '없음';
                        int skyIndex = int.parse(widget.skyStatusList[index].fcstValue ?? '0');
                        String skyStatus = widget.skyStatusList[index].weatherCategory?.codeValues?[skyIndex] ?? '';

                        int iconIndex = Utils.getIconIndex(rainStatus: rainStatus, skyStatus: skyStatus, currentTime: currentTime, sunrise: widget.sunrise, sunset: widget.sunset);

                        double progress = ((int.parse(temperature) - minTemperatureValue) / (maxTemperatureValue - minTemperatureValue));

                        return _weatherItem(
                          temperature: temperature,
                          progress: progress,
                          iconName: '${kWeatherIconList[iconIndex]}_on',
                          rainPercent: rainPercent,
                          timeText: timeText,
                          index: index,
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [kWidgetGradientLeft, kWidgetGradientRight],
                        ),
                      ),
                    ),

                    const Spacer(),

                    Container(
                      width: 50,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [kWidgetGradientLeft, kWidgetGradientRight],
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
                  padding: const EdgeInsets.only(right: 14),
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
    String temperature = '0',
    double progress = 0,
    String iconName = '',
    int rainPercent = 0,
    String timeText = '',
    int index = 0,
  }) {
    return Container(
      width: 55,
      margin: index == 0 ? const EdgeInsets.only(left: 14) : null,
      child: Column(
        children: [
          HeyText.title3Bold(
            '${isFahrenheit.value ? Utils.celsiusToFahrenheit(double.parse(temperature)) : temperature}°',
            fontSize: kFont16,
            color: kTextDisabledColor,
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: RotatedBox(
              quarterTurns: 3,
              child: SizedBox(
                width: 60,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(10.0),
                  backgroundColor: kButtonColor,
                  valueColor: const AlwaysStoppedAnimation<Color>( kProgressForegroundColor),
                  value: progress,
                  minHeight: 6,
                ),
              ),
            ),
          ),

          SvgUtils.weatherIcon(
            context,
            iconName,
            width: 32,
            height: 32,
          ),

          const SizedBox(height: 1.5),
          HeyText.caption1(
            '$rainPercent%',
            color: rainPercent > 0 ? kPrimarySecondColor : Colors.transparent,
          ),
          const Spacer(),
          HeyText.subHeadline(
            timeText.isEmpty ? 'now'.tr : timeText,
            fontSize: kFont12,
            color: timeText.isEmpty ? kTextPointColor : kTextDisabledColor,
          ),
        ],
      ),
    );
  }
}