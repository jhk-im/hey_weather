import 'package:hive/hive.dart';

part 'user_notification_entity.g.dart';

@HiveType(typeId: 1)
class UserNotificationEntity extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? dateTime;
  @HiveField(2)
  bool? isOn;
}
