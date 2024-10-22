import 'package:dio/dio.dart';
import 'package:hey_weather/repository/soruce/remote/model/address_response.dart';
import 'package:hey_weather/repository/soruce/remote/model/search_address_response.dart';
import 'package:retrofit/retrofit.dart';

part 'address_api_service.g.dart';

@RestApi()
abstract class AddressApiService {
  factory AddressApiService(Dio dio, {required String baseUrl}) {
    return _AddressApiService(dio, baseUrl: baseUrl);
  }

  @GET("/v2/local/geo/coord2regioncode.json")
  Future<AddressResponse> getAddressWithCoordinate(
      @Query('x') double x, @Query('y') double y);

  @GET("/v2/local/search/address.json")
  Future<SearchAddressResponse> getSearchAddress(@Query('query') String query);
}
