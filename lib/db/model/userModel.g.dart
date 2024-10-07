// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsermodelAdapter extends TypeAdapter<Usermodel> {
  @override
  final int typeId = 3;

  @override
  Usermodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usermodel(
      username: fields[0] as String,
      password: fields[1] as String,
      webImageBytes: fields[3] as Uint8List?,
      profileImagePath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Usermodel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.profileImagePath)
      ..writeByte(3)
      ..write(obj.webImageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsermodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
