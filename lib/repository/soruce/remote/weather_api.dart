import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class WeatherApi {
  static const kakaoUrl = "dapi.kakao.com";
  static final kakaoApiKey = dotenv.env['KAKAO_API_KEY'];

  // 좌표로 주소 검색
  Future<http.Response> getAddressWithCoordinate(double x, double y) async {
    var url = Uri.https(kakaoUrl, '/v2/local/geo/coord2regioncode.json', {
      'x': '$x',
      'y': '$y',
    });
    var headers = <String, String>{
      'Authorization': 'KakaoAK $kakaoApiKey',
    };
    return await http.get(url, headers: headers);
  }

  // 주소로 좌표 검색
  Future<http.Response> getSearchAddress(String query) async {
    var url = Uri.https(kakaoUrl, '/v2/local/search/address.json', {
      'query': query,
    });
    var headers = <String, String>{
      'Authorization': 'KakaoAK $kakaoApiKey',
    };
    return await http.get(url, headers: headers);
  }

  static const weatherUrl = "apis.data.go.kr";
  static final serviceKey = dotenv.env['SERVICE_KEY'];

  // 초단기 실황
  // 기온, 습도, 강수량, 강수 형태, 풍속, 풍향
  Future<http.Response> getUltraShortTerm(
      String date, String time, int x, int y) async {
    var url = Uri.https(
        weatherUrl, '/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst', {
      'dataType': 'JSON',
      'serviceKey': serviceKey ?? '',
      'numOfRows': '10',
      'pageNo': '1',
      'base_date': date,
      'base_time': time,
      'nx': '$x',
      'ny': '$y',
    });
    return await http.get(url);
  }

  // 초단기 예보
  Future<http.Response> getUltraShortTermSixTime(int x, int y) async {
    DateTime now = DateTime.now();
    DateTime oneHourBefore = now.subtract(const Duration(hours: 1));
    String formattedDate = DateFormat('yyyyMMdd HHmm').format(oneHourBefore);
    List<String> formatted = formattedDate.split(' ');

    var url = Uri.https(
        weatherUrl, '/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst', {
      'dataType': 'JSON',
      'serviceKey': serviceKey ?? '',
      'numOfRows': '60',
      'pageNo': '1',
      'base_date': formatted[0],
      'base_time': formatted[1],
      'nx': '$x',
      'ny': '$y',
    });
    return await http.get(url);
  }

  // 단기 예보
  Future<http.Response> getShortTerm(String date, String time, int x, int y,
      {String numberOfRows = '600'}) async {
    var url = Uri.https(
        weatherUrl, '/1360000/VilageFcstInfoService_2.0/getVilageFcst', {
      'dataType': 'JSON',
      'serviceKey': serviceKey ?? '',
      'numOfRows': numberOfRows,
      'pageNo': '1',
      'base_date': date,
      'base_time': time,
      'nx': '$x',
      'ny': '$y',
    });
    return await http.get(url);
  }

  // 중기 기온 예보
  Future<http.Response> getMidTermTemperature(String tmFc, String regId) async {
    var url = Uri.https(weatherUrl, '/1360000/MidFcstInfoService/getMidTa', {
      'serviceKey': serviceKey ?? '',
      'dataType': 'JSON',
      'numOfRows': '10',
      'pageNo': '1',
      'tmFc': tmFc,
      'regId': regId,
    });
    return await http.get(url);
  }

  // 중기 육상 예보
  Future<http.Response> getMidTermLand(String tmFc, String regId) async {
    var url =
        Uri.https(weatherUrl, '1360000/MidFcstInfoService/getMidLandFcst', {
      'serviceKey': serviceKey ?? '',
      'dataType': 'JSON',
      'numOfRows': '10',
      'pageNo': '1',
      'tmFc': tmFc,
      'regId': regId,
    });
    return await http.get(url);
  }

  // 자외선 지수 조회
  Future<http.Response> getUltraviolet(String time, String areaNo) async {
    var url =
        Uri.https(weatherUrl, '/1360000/LivingWthrIdxServiceV4/getUVIdxV4', {
      'serviceKey': serviceKey ?? '',
      'dataType': 'JSON',
      'numOfRows': '10',
      'pageNo': '1',
      'time': time,
      'areaNo': areaNo,
    });
    return await http.get(url);
  }

  // 좌표로 출몰시간 조회 (XML)
  Future<http.Response> getRiseSetInfoWithCoordinate(
      String locdate, double longitude, double latitude) async {
    var url = Uri.https(weatherUrl,
        '/B090041/openapi/service/RiseSetInfoService/getLCRiseSetInfo', {
      'serviceKey': serviceKey ?? '',
      'locdate': locdate,
      'longitude': '$longitude',
      'latitude': '$latitude',
      'dnYn': 'Y',
    });
    return await http.get(url);
  }

  // 측정소별 실시간 대기오염 측정정보 조회
  /*Future<http.Response> getFineDust(String sName) async {
    var url = Uri.https(weatherUrl, '/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty', {
      'returnType': 'JSON',
      'serviceKey': serviceKey ?? '',
      'numOfRows': '1',
      'pageNo': '1',
      'dataTerm': 'DAILY',
      'stationName': sName,
      'ver': '1.1',
    });
    return await http.get(url);
  }*/

  // 도시별 실시간 대기오염 측정정보 조회
  // 전국, 서울, 부산, 대구, 인천, 광주, 대전, 울산, 경기, 강원, 충북, 충남, 전북, 전남, 경북, 경남, 제주, 세종
  Future<http.Response> getFineDustWithCity(String cityName) async {
    var url = Uri.https(
        weatherUrl, '/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty', {
      'returnType': 'JSON',
      'serviceKey': serviceKey ?? '',
      'numOfRows': '1',
      'pageNo': '1',
      'sidoName': cityName,
      'ver': '1.1',
    });
    return await http.get(url);
  }
}
