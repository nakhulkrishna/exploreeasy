// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TripModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 1;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripModel(
      TripwebImageBytes: fields[10] as Uint8List?,
      contacts: (fields[5] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      photoPaths: (fields[7] as List).cast<String>(),
      tripName: fields[0] as String,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
      travelersCount: fields[3] as int,
      accommodation: fields[4] as String,
      budget: fields[6] as double,
      completed: fields[9] as bool,
      id: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.tripName)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.travelersCount)
      ..writeByte(4)
      ..write(obj.accommodation)
      ..writeByte(5)
      ..write(obj.contacts)
      ..writeByte(6)
      ..write(obj.budget)
      ..writeByte(7)
      ..write(obj.photoPaths)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.completed)
      ..writeByte(10)
      ..write(obj.TripwebImageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
