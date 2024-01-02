import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_weather/common/constants.dart';
import 'package:hey_weather/common/image_utils.dart';
import 'package:hey_weather/pages/home/home_controller.dart';
import 'package:hey_weather/widgets/buttons/hey_elevated_button.dart';
import 'package:hey_weather/widgets/buttons/thunder_custom_button.dart';
import 'package:hey_weather/widgets/loading_widget.dart';


class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
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
                          iconName: 'icon_plus',
                          onPressed: () {},
                        ),

                        HeyCustomButton.icon(
                          icon: ImageUtils.icon(context, 'icon_circle', width: 20, height: 20),
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
                          iconName: 'icon_arrow_right',
                          text: 'Btn',
                          isLeftIcon: false,
                          onPressed: () {},
                        ),

                        HeyElevatedButton.secondaryIcon3(
                          context,
                          iconName: 'icon_arrow_right',
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
                    margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
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
                ],
              ),
            ),
            Obx(() => LoadingWidget(controller.isLoading)),
          ],
        ),
      ),
    );
  }
}

class HeyCustomSwitch extends StatefulWidget {
  const HeyCustomSwitch({
    super.key,
    required this.onChange,
    required this.isSelected,
  });

  final Function onChange;
  final bool isSelected;

  @override
  State<HeyCustomSwitch> createState() => _HeyCustomSwitchState();
}

class _HeyCustomSwitchState extends State<HeyCustomSwitch> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          widget.onChange.call(!widget.isSelected);
        },
        child: Container(
          width: 44, // 전체 Switch의 가로 크기
          height: 27, // 전체 Switch의 세로 크기
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), // 둥근 테두리로 만들기
              color: widget.isSelected ? kPrimaryDarkerColor : kTextDisabledColor
          ),
          child: Stack(
            children: [
              Positioned(
                left: widget.isSelected ? 20 : 1.5,
                top: 1.5,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

