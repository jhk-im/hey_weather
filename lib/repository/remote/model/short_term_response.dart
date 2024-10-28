import 'package:hey_weather/repository/remote/model/weather_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'short_term_response.g.dart';

@JsonSerializable()
class ShortTermResponse {
  final ResponseData response;

  ShortTermResponse({
    required this.response,
  });

  factory ShortTermResponse.fromJson(Map<String, dynamic> json) =>
      _$ShortTermResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShortTermResponseToJson(this);
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
  final List<ShortTerm>? item;

  Items({
    this.item,
  });

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class ShortTerm {
  String? baseDate;
  String? baseTime;
  String? category;
  int? nx;
  int? ny;
  String? obsrValue;
  String? fcstDate;
  String? fcstTime;
  String? fcstValue;
  WeatherCategory? weatherCategory;

  ShortTerm({
    this.baseDate,
    this.baseTime,
    this.category,
    this.nx,
    this.ny,
    this.obsrValue,
    this.fcstDate,
    this.fcstTime,
    this.fcstValue,
  });

  factory ShortTerm.fromJson(Map<String, dynamic> json) =>
      _$ShortTermFromJson(json);

  Map<String, dynamic> toJson() => _$ShortTermToJson(this);
}
