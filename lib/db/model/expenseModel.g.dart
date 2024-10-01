// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseModelAdapter extends TypeAdapter<ExpenseModel> {
  @override
  final int typeId = 2;

  @override
  ExpenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseModel(
      addedTime: fields[4] as DateTime,
      itemName: fields[0] as String,
      amount: fields[1] as double,
      tripId: fields[2] as String,
    )..id = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, ExpenseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.tripId)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.addedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
