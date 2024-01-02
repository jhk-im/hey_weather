import 'package:flutter/material.dart';
import 'package:hey_weather/common/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(this.isVisible, {super.key});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        color: kElevationColor.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(
            color: kPrimaryDarkerColor,
          ),
        ),
      ),
    );
  }
}
