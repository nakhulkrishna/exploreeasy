import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'TripModel.g.dart';

@HiveType(typeId: 1)
class TripModel {
  @HiveField(0)
  final String tripName;

  @HiveField(1)
  final DateTime startDate;

  @HiveField(2)
  final DateTime endDate;

  @HiveField(3)
  final int travelersCount;

  @HiveField(4)
  final String accommodation;

  @HiveField(5)
  final List<Map<String, String>> contacts; // Add this field

  @HiveField(6)
  final double budget;

  @HiveField(7)
  final List<String> photoPaths;

  @HiveField(8)
  final String id;

  @HiveField(9)
  bool completed;

  TripModel({
    required this.contacts,
    required this.photoPaths,
    required this.tripName,
    required this.startDate,
    required this.endDate,
    required this.travelersCount,
    required this.accommodation,
    required this.budget,
    this.completed = false,
    String? id, // Optional id parameter
  }) : id = id ?? Uuid().v4(); // Generate a new id only if none is provided
}
