import 'package:dio/dio.dart';
import 'package:hey_weather/repository/soruce/remote/model/live_ultra_short_term_response.dart';
import 'package:retrofit/retrofit.dart';

part 'weather_api_service.g.dart';

@RestApi()
abstract class WeatherApiService {
  factory WeatherApiService(Dio dio, {required String baseUrl}) {
    return _WeatherApiService(dio, baseUrl: baseUrl);
  }

  /// 초단기 실황
  /// 기온, 습도, 강수량, 강수 형태, 풍속, 풍향
  @GET("/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst")
  Future<LiveUltraShortTermResponse> getLiveUltraShortTerm(
      @Query('numOfRows') String numOfRows,
      @Query('pageNo') String pageNo,
      @Query('base_date') String date,
      @Query('base_time') String time,
      @Query('nx') int x,
      @Query('ny') int y);
}
