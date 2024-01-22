import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/image_utils.dart';
import 'package:hey_weather/pages/home/home_controller.dart';
import 'package:hey_weather/widgets/loading_widget.dart';


class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Stack(
          children: [
            //_samples(context),
            // Header
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Row(
                children: [
                  Row(
                    children: [
                      ImageUtils.icon(context, 'location'),
                      const SizedBox(width: 6),
                      HeyText.body(controller.addressText, color: kTextSecondaryColor),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      print('map');
                    },
                    child: ImageUtils.icon(context, 'map'),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      print('setting');
                      controller.showOnboardBottomSheet();
                    },
                    child: ImageUtils.icon(context, 'setting'),
                  ),
                ],
              ),
            ),

            Obx(() => LoadingWidget(controller.isLoading)),
          ],
        )),
      ),
    );
  }


  /*Widget _samples(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buttons(context),
          _cards(context),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, left: 20),
          child: HeyText.largeTitleBold('Buttons'),
        ),

        Container(
          margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: HeyElevatedButton.primaryText1(
            text: 'PrimaryText',
            onPressed: () {},
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: HeyElevatedButton.secondaryIcon1(
            context,
            text: 'SecondaryText',
            onPressed: () {},
          ),
        ),

        Container(
            margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HeyElevatedButton.primaryText2(
                  text: 'Btn',
                  onPressed: () {},
                ),

                HeyElevatedButton.secondaryText2(
                  text: 'Btn',
                  onPressed: () {},
                ),

                HeyElevatedButton.secondaryIcon2(
                  context,
                  iconName: 'plus',
                  onPressed: () {},
                ),

                HeyCustomButton.icon(
                  icon: ImageUtils.icon(context, 'circle', width: 20, height: 20),
                  onPressed: () {

                  },
                ),
              ],
            )
        ),

        Container(
          margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HeyElevatedButton.primaryIcon3(
                context,
                iconName: 'arrow_right',
                text: 'Btn',
                isLeftIcon: false,
                onPressed: () {},
              ),

              HeyElevatedButton.secondaryIcon3(
                context,
                iconName: 'arrow_right',
                text: 'Btn',
                isLeftIcon: false,
                onPressed: () {},
              ),

              HeyElevatedButton.primaryText3(
                text: 'Btn',
                onPressed: () {},
              ),

              HeyElevatedButton.secondaryText3(
                text: 'Btn',
                onPressed: () {},
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
          child: Row(
            children: [
              Flexible(
                child: HeyElevatedButton.primaryPopup(
                  text: 'Popup',
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: HeyElevatedButton.secondaryPopup(
                  text: 'Popup',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 20),
          child: Row(
            children: [
              HeyCustomSwitch(
                onChange: (value) {

                },
                isSelected: true,
              ),
              const SizedBox(width: 10),
              HeyCustomSwitch(
                onChange: (value) {

                },
                isSelected: false,
              ),
            ],
          ),
        ),

        const Divider(color: kIconColor, height: 1),
      ],
    );
  }

  Widget _cards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, left: 20),
          child: HeyText.largeTitleBold('Cards'),
        ),

        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                HeyWeatherSmallCard(
                  title: 'humidity'.tr,
                  iconName: 'humidity',
                  subtitle: '낮음',
                  state: '16',
                  secondState: '17',
                ),
                HeyWeatherSmallCard(
                  title: 'humidity'.tr,
                  iconName: 'humidity',
                  subtitle: '보통',
                  state: '55',
                  secondState: '32',
                ),
                HeyWeatherSmallCard(
                  title: 'humidity'.tr,
                  iconName: 'humidity',
                  subtitle: '높음',
                  state: '80',
                  secondState: '80',
                ),

                HeyWeatherSmallCard(
                  title: 'wind'.tr,
                  iconName: 'wind',
                  subtitle: '없음',
                  state: '3',
                  secondState: '북동',
                ),
                HeyWeatherSmallCard(
                  title: 'wind'.tr,
                  iconName: 'wind',
                  subtitle: '약함',
                  state: '13',
                  secondState: '남서',
                ),
                HeyWeatherSmallCard(
                  title: 'wind'.tr,
                  iconName: 'wind',
                  subtitle: '보통',
                  state: '23',
                  secondState: '남동',
                ),
                HeyWeatherSmallCard(
                  title: 'wind'.tr,
                  iconName: 'wind',
                  subtitle: '강함',
                  state: '33',
                  secondState: '남동',
                ),

                // 강수
                HeyWeatherSmallCard(
                  title: 'rain'.tr,
                  iconName: 'rain',
                  subtitle: '없음',
                  state: '0',
                ),
                HeyWeatherSmallCard(
                  title: 'rain'.tr,
                  iconName: 'rain',
                  subtitle: '확률 50%',
                  state: '13',
                  secondState: '20분',
                ),
                HeyWeatherSmallCard(
                  title: 'rain'.tr,
                  iconName: 'rain',
                  subtitle: '확률 100%',
                  state: '32',
                  secondState: '10분',
                ),

                // 자외선
                HeyWeatherSmallCard(
                  title: 'ultraviolet'.tr,
                  iconName: 'ultraviolet',
                  subtitle: '낮음',
                  state: '3',
                  secondState: '3',
                ),
                HeyWeatherSmallCard(
                  title: 'ultraviolet'.tr,
                  iconName: 'ultraviolet',
                  subtitle: '보통',
                  state: '10',
                ),
                HeyWeatherSmallCard(
                  title: 'ultraviolet'.tr,
                  iconName: 'ultraviolet',
                  subtitle: '높음',
                  state: '40',
                ),
                HeyWeatherSmallCard(
                  title: 'ultraviolet'.tr,
                  iconName: 'ultraviolet',
                  subtitle: '매우 높음',
                  state: '50',
                  secondState: '',
                ),
                HeyWeatherSmallCard(
                  title: 'ultraviolet'.tr,
                  iconName: 'ultraviolet',
                  subtitle: '위험',
                  state: '80',
                ),

                // 미세먼지
                HeyWeatherSmallCard(
                  title: 'fine_dust'.tr,
                  iconName: 'fine_dust',
                  subtitle: '최고 좋음',
                  state: '0',
                ),
                HeyWeatherSmallCard(
                  title: 'fine_dust'.tr,
                  iconName: 'fine_dust',
                  subtitle: '좋음',
                  state: '3',
                ),
                HeyWeatherSmallCard(
                  title: 'fine_dust'.tr,
                  iconName: 'fine_dust',
                  subtitle: '보통',
                  state: '10',
                ),
                HeyWeatherSmallCard(
                  title: 'fine_dust'.tr,
                  iconName: 'fine_dust',
                  subtitle: '나쁨',
                  state: '15',
                ),
                HeyWeatherSmallCard(
                  title: 'fine_dust'.tr,
                  iconName: 'fine_dust',
                  subtitle: '매우 나쁨',
                  state: '20',
                ),

                // 초미세먼지
                HeyWeatherSmallCard(
                  title: 'ultra_fine_dust'.tr,
                  iconName: 'fine_dust',
                  subtitle: '좋음',
                  state: '2',
                ),

                // 체감온도
                HeyWeatherSmallCard(
                  title: 'wind_chill'.tr,
                  iconName: 'fine_dust',
                  state: '30 28',
                ),

                // 일출 일몰
                const HeyWeatherMediumCard(
                  sunrise: '7시 34분',
                  sunset: '5시 34분',
                ),

                // 시간대별 날씨
                const HeyWeatherLargeCard(
                  sunrise: '7시 34분',
                  sunset: '5시 34분',
                ),

                // 주간 날씨
                const HeyWeatherBigCard(
                  sunrise: '7시 34분',
                  sunset: '5시 34분',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        const Divider(color: kIconColor, height: 1),
      ],
    );
  }*/
}

