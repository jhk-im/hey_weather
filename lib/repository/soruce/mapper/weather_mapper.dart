import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/local/entity/user_notification_entity.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';
import 'package:hey_weather/repository/soruce/remote/model/user_notification.dart';

// 주소
extension ToAddressEntity on Address {
  AddressEntity toAddressEntity() {
    var entity = AddressEntity();
    entity.id = id;
    entity.addressName = addressName;
    entity.region1depthName = region1depthName;
    entity.region2depthName = region2depthName;
    entity.region3depthName = region3depthName;
    entity.region4depthName = region4depthName;
    entity.x = x;
    entity.y = y;
    entity.code = code;
    entity.regionType = regionType;
    entity.createDateTime = createDateTime;
    return entity;
  }
}

extension ToAddress on AddressEntity {
  Address toAddress() {
    var address = Address(
      id: id,
      addressName: addressName,
      region1depthName: region1depthName,
      region2depthName: region2depthName,
      region3depthName: region3depthName,
      region4depthName: region4depthName,
      x: x,
      y: y,
      code: code,
      regionType: regionType,
      createDateTime: createDateTime,
    );
    return address;
  }
}

// 알림
extension ToUserNotificationEntity on UserNotification {
  UserNotificationEntity toUserNotificationEntity() {
    var entity = UserNotificationEntity();
    entity.id = id;
    entity.dateTime = dateTime;
    entity.isOn = isOn;
    return entity;
  }
}

extension ToUserNotification on UserNotificationEntity {
  UserNotification toUserNotification() {
    var userNotification = UserNotification(
      id: id,
      dateTime: dateTime,
      isOn: isOn,
    );
    return userNotification;
  }
}