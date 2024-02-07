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
    'add': '추가',
    'edit': '편집',
    'done': '완료',
    'setting' : '설정',
    'setting_location': '지역 설정',
    'setting_notification' : '알림 설정',
    'setting_temperature' : '온도 설정',
    'send_opinion': '의견 보내기',
    'current_location': '현재 위치',
    'recent_added': '최근 추가',
    'question_add_1': '을 추가할까요?',
    'question_add_2': '를 추가할까요?',
    'location_permission_message': '현재 위치의 날씨 정보를 보려면\n위치 권한 허용이 필요해요!',
    'on' : 'ON',
    'off' : 'OFF',
    'fahrenheit': '°F',
    'fahrenheit_text': '(화씨 온도)',
    'celsius': '°C',
    'celsius_text': '(섭씨 온도)',
    'receive_notification': '알림 받기',
    'home_tab_1': 'MY',
    'home_tab_2': 'ALL',
    'home_add_desc': '자주 보는 날씨 정보 추가',
    'coffee_title_1': '헤이 날씨가 도움이 되셨나요?',
    'coffee_title_2': '응원의 커피 보내기',

    // Weather
    'humidity' : '습도',
    'wind' : '바람',
    'rain' : '강수',
    'ultraviolet': '자외선',
    'dust': '대기질',
    'dust_fine': '미세',
    'dust_ultra': '초미세',
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

    // Dialog
    'dialog_setting_title': '설정하러 이동할까요??',
    'dialog_setting_subtitle': '시스템 알림이 꺼져 있어 알림 기능을 켤 수 없어요. 설정에서 알림을 켜주세요',
    'dialog_setting_ok': '설정 바로가기',

    // toast
    'toast_added_location': '지역이 추가되었어요',

    // hint
    'hint_address_input': '추가할 지역을 입력하세요',
  };
}