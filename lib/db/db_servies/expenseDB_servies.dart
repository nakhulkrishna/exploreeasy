import 'package:exploreesy/db/model/expenseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<ExpenseModel>> expenseNotifier = ValueNotifier([]);

Future<void> addExpense(ExpenseModel value) async {
  final expenseDB = await Hive.openBox<ExpenseModel>("expense_db");
  await expenseDB.put(value.id, value);
  await getExpensesByTripId(value.tripId);
}

Future<void> getExpensesByTripId(String tripId) async {
  final expenseDB = await Hive.openBox<ExpenseModel>("expense_db");

  expenseNotifier.value.clear();

  List<ExpenseModel> filteredExpenses =
      expenseDB.values.where((expense) => expense.tripId == tripId).toList();

  expenseNotifier.value.addAll(filteredExpenses);
  expenseNotifier.notifyListeners();

  for (var expense in filteredExpenses) {
    print("Item name = ${expense.itemName}");
    print("Item amount = ${expense.amount}");
    print("Item trip id = ${expense.tripId}");
  }

  expenseNotifier.notifyListeners();
}

Future<void> deleteExpense(ExpenseModel expense) async {
  final expenseDB = await Hive.openBox<ExpenseModel>("expense_db");

  await expenseDB.delete(expense.id); // Remove expense by its unique id

  await getExpensesByTripId(expense.tripId); // Refresh the list after deletion
}

Future<void> updateExpense(ExpenseModel expense) async {
  final expenseDB = await Hive.openBox<ExpenseModel>("expense_db");

  await expenseDB.put(expense.id, expense);

  await getExpensesByTripId(
      expense.tripId); // Refresh the list to reflect the update
}
