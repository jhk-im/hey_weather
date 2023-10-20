import 'package:get/get.dart';

class TranslationsInfo extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ko': ko,
  };

  final Map<String, String> enUS = {
    'title': 'Hey, Weather',
  };

  final Map<String, String> ko = {
    'title': '헤이, 날씨',
  };
}