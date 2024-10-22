import 'package:json_annotation/json_annotation.dart';

part 'search_address_response.g.dart';

@JsonSerializable()
class SearchAddressResponse {
  final int? code;
  final String? msg;
  final Meta? meta;
  final List<SearchAddressResult>? documents;

  SearchAddressResponse({
    this.code,
    this.msg,
    this.meta,
    this.documents,
  });

  factory SearchAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAddressResponseToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: 'total_count')
  final int? totalCount;
  @JsonKey(name: 'pageable_count')
  final int? pageableCount;
  @JsonKey(name: 'is_end')
  final bool? isEnd;

  Meta({
    this.totalCount,
    this.pageableCount,
    this.isEnd,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class SearchAddressResult {
  @JsonKey(name: 'address_name')
  final String? addressName;
  @JsonKey(name: 'address_type')
  final String? addressType;
  final double? x;
  final double? y;

  SearchAddressResult({this.addressName, this.addressType, this.x, this.y});

  factory SearchAddressResult.fromJson(Map<String, dynamic> json) =>
      _$SearchAddressResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAddressResultToJson(this);
}
