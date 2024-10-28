import 'package:hey_weather/repository/soruce/local/entity/short_term_entity.dart';
import 'package:hive/hive.dart';

part 'short_term_list_entity.g.dart';

@HiveType(typeId: 8)
class ShortTermListEntity extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  List<ShortTermEntity>? items;
}
