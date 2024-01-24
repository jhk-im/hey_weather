import 'package:hive/hive.dart';

part 'address_entity.g.dart';

@HiveType(typeId: 0)
class AddressEntity extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? addressName;
  @HiveField(2)
  String? region1depthName;
  @HiveField(3)
  String? region2depthName;
  @HiveField(4)
  String? region3depthName;
  @HiveField(5)
  String? region4depthName;
  @HiveField(6)
  double? x;
  @HiveField(7)
  double? y;
  @HiveField(8)
  String? code;
  @HiveField(9)
  String? regionType;
}