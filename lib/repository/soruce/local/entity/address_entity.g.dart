// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressEntityAdapter extends TypeAdapter<AddressEntity> {
  @override
  final int typeId = 3;

  @override
  AddressEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressEntity()
      ..addressName = fields[0] as String?
      ..region1depthName = fields[1] as String?
      ..region2depthName = fields[2] as String?
      ..region3depthName = fields[3] as String?
      ..region4depthName = fields[4] as String?
      ..x = fields[5] as double?
      ..y = fields[6] as double?
      ..code = fields[7] as String?
      ..regionType = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, AddressEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.addressName)
      ..writeByte(1)
      ..write(obj.region1depthName)
      ..writeByte(2)
      ..write(obj.region2depthName)
      ..writeByte(3)
      ..write(obj.region3depthName)
      ..writeByte(4)
      ..write(obj.region4depthName)
      ..writeByte(5)
      ..write(obj.x)
      ..writeByte(6)
      ..write(obj.y)
      ..writeByte(7)
      ..write(obj.code)
      ..writeByte(8)
      ..write(obj.regionType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
