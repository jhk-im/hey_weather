import 'package:hive/hive.dart';

part 'weather_ultra_short_term_entity.g.dart';

@HiveType(typeId: 6)
class WeatherUltraShortTermEntity extends HiveObject {
  @HiveField(0)
  String category;
  @HiveField(1)
  String obsrValue;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? unit;
  @HiveField(4)
  List<String>? codeValues;
  @HiveField(5)
  String? baseDate;
  @HiveField(6)
  String? baseTime;
  @HiveField(7)
  int? nx;
  @HiveField(8)
  int? ny;
  WeatherUltraShortTermEntity({required this.category, required this.obsrValue,});
}