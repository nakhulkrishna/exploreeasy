import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/material.dart';

class Custome_TextFieldd extends StatelessWidget {
  final String labelText;
  final String hintText;

  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const Custome_TextFieldd({
    super.key,
    required this.labelText,
    required this.hintText,
    this.onTap,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      onTap: onTap,
      decoration: InputDecoration(
        // Label text, hint, or helper text
        labelText: labelText,
        labelStyle: TextStyle(color: AppColors.darkBlue, fontSize: 16),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),

        // Fully customized border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.darkBlue, // Custom border color on focus
            width: 1.5, // Custom border thickness
          ),
        ),

        // Fully customized border when not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.darkBlue, // Custom border color when not focused
            width: 1.5,
          ),
        ),

        // Error state styling
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red, // Custom border color for error
            width: 1.5,
          ),
        ),

        // Border style for when the text field is in error but focused
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red, // Custom error border when focused
            width: 2.0,
          ),
        ),

        // Padding inside the text field
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
      cursorColor: AppColors.lightBlue, // Custom cursor color
      style: TextStyle(
          color: Colors.black, fontSize: 16), // Text style inside the field
    );
  }
}
