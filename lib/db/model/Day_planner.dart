import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'Day_planner.g.dart';

@HiveType(typeId: 4)
class DayPlanModel {
  @HiveField(0)
  final String Tripid;
  @HiveField(1)
  final String? plansName;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final int indexofday;
  @HiveField(4)
  final DateTime formTime;
  @HiveField(5)
  final DateTime toTime;
  @HiveField(6)
  final String? description;
  @HiveField(7)
  final String? transportaion;

  @HiveField(8)
  final String id;
  DayPlanModel(
      {required this.transportaion,
      required this.formTime,
      required this.toTime,
      required this.description,
      required this.indexofday,
      required this.Tripid,
      required this.plansName,
      required this.date,
      String? id})
      : id = id ?? Uuid().v4();
}
