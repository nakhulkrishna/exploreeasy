import 'package:flutter/material.dart';

class ExpenseSheet extends StatefulWidget {
  final Function(String, double) addExpense;
  final List<Map<String, dynamic>> expenseList;

  const ExpenseSheet(
      {super.key, required this.addExpense, required this.expenseList});

  @override
  _ExpenseSheetState createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends State<ExpenseSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height * 0.9, // Full-screen height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Expenses",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Form to add new expense
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Expense title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              widget.addExpense(title, amount);
              titleController.clear();
              amountController.clear();
            },
            child: const Text("Add Expense"),
          ),
          const SizedBox(height: 20),
          // List of expenses
          Expanded(
            child: ListView.builder(
              itemCount: widget.expenseList.length,
              itemBuilder: (context, index) {
                final expense = widget.expenseList[index];
                return ListTile(
                  title: Text(expense['title']),
                  trailing: Text("\$${expense['amount'].toStringAsFixed(2)}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
