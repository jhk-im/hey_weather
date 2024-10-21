import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgUtils extends SvgPicture {
  SvgUtils.icon(
    BuildContext context,
    String name, {
    super.key,
    super.width = 24,
    super.height = 24,
    super.fit,
    super.allowDrawingOutsideViewBox,
    Color? color,
  }) : super.asset(
          'assets/images/icons/basic/icon_$name.svg',
          colorFilter: color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null,
        );

  SvgUtils.weatherIcon(
    BuildContext context,
    String name, {
    super.key,
    super.width = 32,
    super.height = 32,
    super.fit,
    super.allowDrawingOutsideViewBox,
    Color? color,
  }) : super.asset(
          'assets/images/icons/weather/icon_$name.svg',
          colorFilter: color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null,
        );

  SvgUtils.svg(
    BuildContext context,
    String name, {
    super.key,
    super.width = 24,
    super.height = 24,
    super.fit,
    super.allowDrawingOutsideViewBox,
    Color? color,
  }) : super.asset(
          'assets/images/svg/icon_$name.svg',
          colorFilter: color != null
              ? ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                )
              : null,
        );
}
