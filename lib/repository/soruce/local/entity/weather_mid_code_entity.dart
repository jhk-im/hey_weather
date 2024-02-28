import 'package:hive/hive.dart';

part 'weather_mid_code_entity.g.dart';

@HiveType(typeId: 9)
class WeatherMidCodeEntity extends HiveObject {
  @HiveField(0)
  String? city;
  @HiveField(1)
  String? code;
}