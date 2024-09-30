// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Day_planner.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayPlanModelAdapter extends TypeAdapter<DayPlanModel> {
  @override
  final int typeId = 4;

  @override
  DayPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayPlanModel(
      transportaion: fields[7] as String?,
      formTime: fields[4] as DateTime,
      toTime: fields[5] as DateTime,
      description: fields[6] as String?,
      indexofday: fields[3] as int,
      id: fields[0] as String,
      plansName: fields[1] as String?,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DayPlanModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plansName)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.indexofday)
      ..writeByte(4)
      ..write(obj.formTime)
      ..writeByte(5)
      ..write(obj.toTime)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.transportaion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
