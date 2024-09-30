// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'expenseModel.g.dart';

@HiveType(typeId: 2)
class ExpenseModel {
  @HiveField(0)
  final String itemName;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  String tripId;

  @HiveField(3)
  String id;

  ExpenseModel({
    required this.itemName,
    required this.amount,
    required this.tripId,
  }) : id = Uuid().v4();

  ExpenseModel copyWith({
    String? itemName,
    double? amount,
    String? tripId,
    String? id,
  }) {
    return ExpenseModel(
      itemName: itemName ?? this.itemName,
      amount: amount ?? this.amount,
      tripId: tripId ?? this.tripId,
    )..id = id ?? this.id; // Note: You may need to set id separately
  }
}
