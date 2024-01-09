import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';

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