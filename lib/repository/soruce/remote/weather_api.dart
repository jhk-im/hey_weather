import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApi {
  static const kakaoUrl = "dapi.kakao.com";
  static final kakaoApiKey = dotenv.env['KAKAO_API_KEY'];

  // 좌표로 주소 검색
  Future<http.Response> getAddressWithCoordinate(double x, double y) async {
    var url =
    Uri.https(kakaoUrl, '/v2/local/geo/coord2regioncode.json', {
      'x': '$x',
      'y': '$y',
    });
    var headers = <String, String> {
      'Authorization': 'KakaoAK $kakaoApiKey',
    };
    return await http.get(url, headers: headers);
  }

  // 주소로 좌표 검색
  Future<http.Response> getSearchAddress(String query) async {
    var url =
    Uri.https(kakaoUrl, '/v2/local/search/address.json', {
      'query': query,
    });
    var headers = <String, String> {
      'Authorization': 'KakaoAK $kakaoApiKey',
    };
    return await http.get(url, headers: headers);
  }

  static const weatherUrl = "apis.data.go.kr";
  static final serviceKey = dotenv.env['SERVICE_KEY'];

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
  Future<http.Response> getRiseSetInfoWithCoordinate(String locdate, double longitude, double latitude) async {
    var url =
    Uri.https(weatherUrl, '/B090041/openapi/service/RiseSetInfoService/getLCRiseSetInfo', {
      'serviceKey': serviceKey ?? '',
      'locdate': locdate,
      'longitude': '$longitude',
      'latitude': '$latitude',
      'dnYn': 'Y',
    });
    return await http.get(url);
  }
}