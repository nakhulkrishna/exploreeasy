import 'package:exploreesy/db/db_servies/expenseDB_servies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:exploreesy/src/utils/widgets/custome_button.dart';
import 'package:exploreesy/src/utils/colors.dart';

import 'package:exploreesy/db/model/expenseModel.dart';

void showBudgetModalSheet(
    BuildContext context, double initialBudget, String tripId) {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemAmountController = TextEditingController();

  double calculateTotalAmountUsed(List<ExpenseModel> expenses, String tripId) {
    return expenses
        .where((expense) => expense.tripId == tripId)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double calculateRemainingBudget(
      double initialBudget, double totalAmountUsed) {
    return initialBudget - totalAmountUsed;
  }

  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return ValueListenableBuilder(
        valueListenable: expenseNotifier,
        builder: (context, List<ExpenseModel> expenseList, Widget? child) {
          final totalAmountUsed = calculateTotalAmountUsed(expenseList, tripId);
          final remainingBudget =
              calculateRemainingBudget(initialBudget, totalAmountUsed);

          return SizedBox(
            height: 700,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Set your Trip Budget",
                    style: GoogleFonts.ptSerif(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.darkBlue),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Budget: ${initialBudget.toStringAsFixed(2)}",
                          style: GoogleFonts.ptSerif(
                            fontSize: 20,
                            color: AppColors.red,
                          ),
                        ),
                        Text(
                          "Total Amount Used: ${totalAmountUsed.toStringAsFixed(2)}",
                          style: GoogleFonts.ptSerif(color: Colors.black),
                        ),
                        Text(
                          "Remaining Budget: ${remainingBudget.toStringAsFixed(2)}",
                          style: GoogleFonts.ptSerif(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:
                              Text("Add Items", style: GoogleFonts.ptSerif()),
                          content: SizedBox(
                            height: 200,
                            child: Column(
                              children: [
                                TextField(
                                  controller: _itemNameController,
                                  decoration: const InputDecoration(
                                    label: Text("Item Name"),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _itemAmountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    label: Text("Item Amount"),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Custome_Button(
                                  onpresed: () {
                                    final double amount = double.parse(
                                        _itemAmountController.text);
                                    final addExpenseList = ExpenseModel(
                                        tripId: tripId,
                                        itemName: _itemNameController.text,
                                        amount: amount);

                                    addExpense(addExpenseList);

                                    Navigator.pop(context); // Close the dialog
                                  },
                                  text: "Continue",
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(CupertinoIcons.add),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: expenseNotifier,
                      builder: (context, List<ExpenseModel> expenseList,
                          Widget? child) {
                        return ListView.builder(
                          itemCount: expenseList.length,
                          itemBuilder: (context, index) {
                            final data = expenseList[index];
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    const SizedBox(width: 5),
                                    SlidableAction(
                                      borderRadius: BorderRadius.circular(10),
                                      onPressed: (context) {
                                        deleteExpense(data);
                                      },
                                      backgroundColor: AppColors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                    const SizedBox(width: 5),
                                    SlidableAction(
                                      borderRadius: BorderRadius.circular(10),
                                      onPressed: (context) {
                                        _itemNameController.text =
                                            data.itemName;
                                        _itemAmountController.text =
                                            data.amount.toString();

                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Edit Expense",
                                                style: GoogleFonts.ptSerif()),
                                            content: SizedBox(
                                              height: 200,
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    controller:
                                                        _itemNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      label: Text("Item Name"),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextField(
                                                    controller:
                                                        _itemAmountController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                      label:
                                                          Text("Item Amount"),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Custome_Button(
                                                    onpresed: () {
                                                      final double amount =
                                                          double.parse(
                                                              _itemAmountController
                                                                  .text);
                                                      final updatedExpense =
                                                          data.copyWith(
                                                        itemName:
                                                            _itemNameController
                                                                .text,
                                                        amount: amount,
                                                      );

                                                      updateExpense(
                                                          updatedExpense);

                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                    },
                                                    text: "Update",
                                                    height: 40,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      backgroundColor: AppColors.darkBlue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    data.itemName,
                                    style: GoogleFonts.ptSerif(fontSize: 20),
                                  ),
                                  trailing: Text(
                                    data.amount.toStringAsFixed(2),
                                    style: GoogleFonts.ptSerif(
                                        fontSize: 20, color: Colors.green),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
