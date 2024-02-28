import 'package:hey_weather/repository/soruce/local/entity/weather_short_term_entity.dart';
import 'package:hive/hive.dart';

part 'weather_short_term_list_entity.g.dart';

@HiveType(typeId: 8)
class WeatherShortTermListEntity extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  List<WeatherShortTermEntity>? items;
}
