import 'package:hey_weather/repository/soruce/local/entity/address_entity.dart';
import 'package:hey_weather/repository/soruce/remote/model/address.dart';

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
