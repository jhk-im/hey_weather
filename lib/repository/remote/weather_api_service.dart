import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'model/live_short_term_response.dart';
import 'model/short_term_response.dart';

part 'weather_api_service.g.dart';

@RestApi()
abstract class WeatherApiService {
  factory WeatherApiService(Dio dio, {required String baseUrl}) {
    return _WeatherApiService(dio, baseUrl: baseUrl);
  }

  /// 초단기 실황
  /// 기온, 습도, 강수량, 강수 형태, 풍속, 풍향
  @GET("/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst")
  Future<LiveShortTermResponse> getLiveShortTerm(
      @Query('numOfRows') String numOfRows,
      @Query('pageNo') String pageNo,
      @Query('base_date') String date,
      @Query('base_time') String time,
      @Query('nx') int x,
      @Query('ny') int y);

  /// 초단기 예보 (현재 시각 - 6시간)
  @GET("/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst")
  Future<ShortTermResponse> getSixTimeShortTerm(
      @Query('numOfRows') String numOfRows,
      @Query('pageNo') String pageNo,
      @Query('base_date') String date,
      @Query('base_time') String time,
      @Query('nx') int x,
      @Query('ny') int y);

  /// 단기 예보 (어제, 오늘, 내일)
  @GET("/1360000/VilageFcstInfoService_2.0/getVilageFcst")
  Future<ShortTermResponse> getShortTerm(
      @Query('numOfRows') String numOfRows,
      @Query('pageNo') String pageNo,
      @Query('base_date') String date,
      @Query('base_time') String time,
      @Query('nx') int x,
      @Query('ny') int y);

  @GET("/B090041/openapi/service/RiseSetInfoService/getLCRiseSetInfo")
  Future<String> getSunRise(
      @Query('locdate') String locdate,
      @Query('longitude') double longitude,
      @Query('latitude') double latitude,
      @Query('dnYn') String stationName);
}
