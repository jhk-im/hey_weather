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
}