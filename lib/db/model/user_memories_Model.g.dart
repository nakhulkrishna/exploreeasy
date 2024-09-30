// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_memories_Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class userMemoriesAdapter extends TypeAdapter<userMemories> {
  @override
  final int typeId = 5;

  @override
  userMemories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return userMemories(
      idOftrip: fields[1] as String,
      caption: fields[2] as String,
      memoriesPhoto: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, userMemories obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idOftrip)
      ..writeByte(2)
      ..write(obj.caption)
      ..writeByte(3)
      ..write(obj.memoriesPhoto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is userMemoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
