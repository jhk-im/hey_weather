import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/hey_bottom_sheet.dart';
import 'package:hey_weather/common/hey_text.dart';
import 'package:hey_weather/common/svg_utils.dart';
import 'package:hey_weather/getx/routes.dart';
import 'package:hey_weather/pages/home/home_controller.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/cards/hey_weather_big_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_dust_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_home_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_large_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_sun_card.dart';
import 'package:hey_weather/widgets/cards/hey_weather_small_card.dart';
import 'package:hey_weather/widgets/loading_widget.dart';
import 'package:permission_handler/permission_handler.dart';


class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double emptyHeight = (MediaQuery.of(context).size.height) - 157;
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Stack(
          children: [
            Column(
              children: [
                // Header 157
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                        splashColor: kBaseColor,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          HeyBottomSheet.showSelectAddressBottomSheet(
                            context,
                            addressList: controller.recentAddressList,
                            currentAddress: controller.currentAddress,
                            onSelectedAddress: (addressId) {
                              controller.logger.d('onSelectedAddress: (addressId) -> $addressId / currentAddress -> ${controller.currentAddress}');
                              if (addressId != controller.currentAddress) {
                                controller.resetData(addressId);
                              }
                            },
                            onMoveToAddress: controller.moveToAddress,
                          );
                        },
                        child: Row(
                          children: [
                            SvgUtils.icon(context, 'location'),
                            const SizedBox(width: 6),
                            HeyText.body(controller.addressText, color: kTextSecondaryColor),
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        splashColor: kBaseColor,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: controller.moveToAddress,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgUtils.icon(context, 'map'),
                        ),
                      ),
                      InkWell(
                        splashColor: kBaseColor,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Get.toNamed(Routes.routeSetting);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgUtils.icon(context, 'setting'),
                        ),
                      ),
                    ],
                  ),
                ),

                // MY, ALL, 편집
                _tab(context, controller.scrollY > 395),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      children: [
                        // Location Permission
                        if (!controller.isLocationPermission) ... {
                          Container(
                            margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                            child: InkWell(
                              splashColor: kBaseColor,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: openAppSettings,
                              child: Container(
                                padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: kBaseColor,
                                ),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    HeyText.footnote('location_permission_message'.tr),
                                    const Spacer(),
                                    SvgUtils.icon(context, 'arrow_right'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        },

                        // Today Card
                        Container(
                          margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                          child: const HeyWeatherHomeCard(
                            weatherStatus: '구름 조금',
                            temperature: '19',
                            message1: '어제보다 1℃ 낮아요',
                            message2: '저녁 6시에 비 올 확률이 80%예요',
                            message3: '미세먼지가 없고 하늘이 깨끗해요',
                          ),
                        ),

                        // Contents
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              // MY, ALL, 편집
                              _tab(context, controller.scrollY < 395),
                              if (!controller.isAllTab) ... {
                                Visibility(
                                  visible: controller.isEmptyWeathers,
                                  child: Container(
                                    width: double.maxFinite,
                                    height: emptyHeight,
                                    color: kHomeBottomColor,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 50),
                                          HeyElevatedButton.secondaryIcon2(
                                            context,
                                            width: 58,
                                            onPressed: () {

                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          HeyText.subHeadline(
                                            'home_add_desc'.tr,
                                            color: kTextDisabledColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              } else ... {
                                // ALL
                                _allWeatherWidgets(context),
                              },
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Obx(() => LoadingWidget(controller.isLoading)),
          ],
        )),
      ),
    );
  }

  Widget _tab(BuildContext context, bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: kHomeBottomColor,
          border: Border(
            top: BorderSide(
              color:   kButtonColor,
              width:1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 24, bottom: 12, right: 20),
          child: controller.isEditMode ? Row(
            children: [
              const SizedBox(width: 10),
              HeyElevatedButton.secondaryIcon2(
                context,
                width: 58,
                onPressed: () {

                },
              ),
              const Spacer(),
              HeyElevatedButton.secondaryText2(
                text: 'done'.tr,
                onPressed: () {
                  controller.editToggle(false);
                },
              ),
            ],
          ) : Row(
            children: [
              InkWell(
                onTap: () {
                  controller.tabToggle(false);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeyText.title3Bold(
                    'home_tab_1'.tr,
                    color: !controller.isAllTab ? kTextDisabledColor : kButtonColor,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.tabToggle(true);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: HeyText.title3Bold(
                    'home_tab_2'.tr,
                    color: controller.isAllTab ? kTextDisabledColor : kButtonColor,
                  ),
                ),
              ),

              if (controller.isEmptyWeathers || controller.isAllTab) ... {
                const SizedBox(height: 48),
              } else ... {
                const Spacer(),
                HeyElevatedButton.secondaryText2(
                  text: 'edit'.tr,
                  onPressed: () {
                    controller.editToggle(true);
                  },
                ),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget _allWeatherWidgets(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      color: kHomeBottomColor,
      child: Center(
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
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
            // 대기질
            const HeyWeatherDustCard(
              fine: '13',
              fineState: '최고 좋음',
              ultra: '10',
              ultraState: '좋음',
            ),
            // 일출 일몰
            const HeyWeatherSunCard(
              sunrise: '7시 34분',
              sunset: '5시 34분',
            ),
            // 습도
            HeyWeatherSmallCard(
              title: 'humidity'.tr,
              iconName: 'humidity',
              subtitle: '낮음',
              state: '16',
              secondState: '17',
            ),
            // 바람
            HeyWeatherSmallCard(
              title: 'wind'.tr,
              iconName: 'wind',
              subtitle: '없음',
              state: '3',
              secondState: '북동',
            ),
            // 강수
            HeyWeatherSmallCard(
              title: 'rain'.tr,
              iconName: 'rain',
              subtitle: '없음',
              state: '0',
            ),
            // 자외선
            HeyWeatherSmallCard(
              title: 'ultraviolet'.tr,
              iconName: 'ultraviolet',
              subtitle: '낮음',
              state: '3',
              secondState: '3',
            ),
            // 체감온도
            HeyWeatherSmallCard(
              title: 'wind_chill'.tr,
              iconName: 'wind_chill',
              state: '30 28',
            ),
          ],
        ),
      ),
    );
  }
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
