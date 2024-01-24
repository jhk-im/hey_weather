import 'package:get/get.dart';

class TranslationsInfo extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'ko': ko,
  };

  final Map<String, String> enUS = {
  };

  final Map<String, String> ko = {
    // Common
    'title': '헤이, 날씨',
    'than_yesterday' : '어제보다',
    'none' : '없음',
    'low' : '낮음',
    'good' : '좋음',
    'weak' : '약함',
    'high' : '높음',
    'normal' : '보통',
    'bad' : '나쁨',
    'very_high' : '매우 높음',
    'strong' : '강함',
    'danger' : '위험',
    'very_bad' : '매우 나쁨',
    'very_good' : '최고 좋음',
    'highest' : '최고',
    'lowest' : '최저',
    'within' : '이내',
    'no_forecast' : '예보 없음',
    'am' : '오전',
    'pm' : '오후',
    'same_yesterday' : '어제와 동일',
    'now' : '지금',
    'today' : '오늘',
    'tomorrow' : '내일',
    'to_add': '추가하기',

    // Weather
    'humidity' : '습도',
    'wind' : '바람',
    'rain' : '강수',
    'ultraviolet': '자외선',
    'fine_dust': '미세먼지',
    'ultra_fine_dust': '초미세먼지',
    'wind_chill': '체감온도',
    'weather_by_time': '시간대별 날씨',
    'weather_week': '주간 날씨',
    'sunrise_sunset' : '일출일몰',

    // Bottom Sheet
    'bs_onboard_title': '자주 보는 날씨를 선택해주세요',
    'bs_onboard_subtitle': '선택한 날씨 정보가 홈 화면에 추가돼요',
    'bs_address_title_1': '어느 지역으로 바꿀까요?',
    'bs_address_title_2': '바꿀 지역이 없어요',
    'bs_address_btn': '다른 지역 찾아보기',
  };
}