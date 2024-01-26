import 'package:flutter/material.dart';

class ImageUtils extends StatelessWidget {
  const ImageUtils({
    super.key,
    required this.iconName,
    this.width,
    this.height
  });

  final String iconName;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/png/$iconName.png',
      width: width,
      height: height,
    );
  }
}
