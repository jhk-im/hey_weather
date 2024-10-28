import 'package:hey_weather/repository/soruce/remote/model/weather_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_ultra_short_term_response.g.dart';

@JsonSerializable()
class LiveUltraShortTermResponse {
  final ResponseData response;

  LiveUltraShortTermResponse({
    required this.response,
  });

  factory LiveUltraShortTermResponse.fromJson(Map<String, dynamic> json) =>
      _$LiveUltraShortTermResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LiveUltraShortTermResponseToJson(this);
}

@JsonSerializable()
class ResponseData {
  final ResponseHeader? header;
  final ResponseBody? body;

  ResponseData({
    this.header,
    this.body,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}

@JsonSerializable()
class ResponseHeader {
  final String? resultCode;
  final String? resultMsg;

  ResponseHeader({
    this.resultCode,
    this.resultMsg,
  });

  factory ResponseHeader.fromJson(Map<String, dynamic> json) =>
      _$ResponseHeaderFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseHeaderToJson(this);
}

@JsonSerializable()
class ResponseBody {
  final String? dataType;
  final Items? items;
  final int? pageNo;
  final int? numOfRows;
  final int? totalCount;

  ResponseBody({
    this.dataType,
    this.items,
    this.pageNo,
    this.numOfRows,
    this.totalCount,
  });

  factory ResponseBody.fromJson(Map<String, dynamic> json) =>
      _$ResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseBodyToJson(this);
}

@JsonSerializable()
class Items {
  final List<LiveUltraShortTerm>? item;

  Items({
    this.item,
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class LiveUltraShortTerm {
  String? baseDate;
  String? baseTime;
  String? category;
  int? nx;
  int? ny;
  String? obsrValue;
  WeatherCategory? weatherCategory;

  LiveUltraShortTerm({
    this.baseDate,
    this.baseTime,
    this.category,
    this.nx,
    this.ny,
    this.obsrValue,
  });

  factory LiveUltraShortTerm.fromJson(Map<String, dynamic> json) =>
      _$LiveUltraShortTermFromJson(json);

  Map<String, dynamic> toJson() => _$LiveUltraShortTermToJson(this);
}
