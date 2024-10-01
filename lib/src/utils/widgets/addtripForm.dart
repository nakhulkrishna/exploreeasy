import 'package:flutter/material.dart';

class AddTripForm extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)?
      validator; // Updated the type to a function that returns String?
  final String hintText;
  final TextInputType keyboardType;

  const AddTripForm({
    Key? key,
    required this.controller,
    required this.validator,
    required this.hintText,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator, // Using the passed validator function
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
