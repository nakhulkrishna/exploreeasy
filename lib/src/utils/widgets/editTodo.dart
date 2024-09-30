import 'package:flutter/material.dart';

void showEditTodoDialog(BuildContext context, int index,
    TextEditingController controller, Function(String) onSave) {
  controller.text = '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Todo'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Edit your todo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
