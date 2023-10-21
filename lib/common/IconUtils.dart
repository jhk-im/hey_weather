import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconUtils extends SvgPicture {

  IconUtils.basic(BuildContext context, String name, {
    super.key,
    super.width = 24,
    super.height = 24,
    super.fit,
    super.allowDrawingOutsideViewBox,
    Color? color,
  }) : super.asset(
    'assets/images/icons/basic/icon_$name.svg',
    colorFilter: color != null ? ColorFilter.mode(
      color,
      BlendMode.srcIn,
    ): null,
  );

  IconUtils.weather(BuildContext context, String name, {
    super.key,
    super.width = 32,
    super.height = 32,
    super.fit,
    super.allowDrawingOutsideViewBox,
    Color? color,
  }) : super.asset(
    'assets/images/icons/weather/icon_$name.svg',
    colorFilter: color != null ? ColorFilter.mode(
      color,
      BlendMode.srcIn,
    ): null,
  );
}