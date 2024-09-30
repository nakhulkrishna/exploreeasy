import 'package:flutter/material.dart';

class AppColors {
  // Define colors with full opacity
  static const Color darkBlue = Color(0xFF2B2D42); // Dark Blue
  static const Color lightBlue = Color(0xFF8D99AE); // Light Blue
  static const Color offWhite = Color(0xFFEDF2F4); // Off White
  static const Color red = Color(0xFFEF233C); // Red
  static const Color darkRed = Color(0xFFD90429); // Dark Red
  static const Color offblue = Color(0xFFCAF0F8); // Dark Red
  static const Color gray = Color(0xFF8D99AE);
  static const Color green = Color(0xFF70E000);
}

// Function to assign different background colors based on index
Color getTileColor(int index) {
  List<Color> colors = [
    Colors.lightGreen[100]!, // Light Green
    Colors.yellow[100]!, // Light Yellow
    Colors.blue[100]!, // Light Blue
    Colors.pink[100]!, // Light Pink
    Colors.orange[100]!, // Light Orange
  ];

  return colors[index % colors.length]; // Cycle through colors based on index
}
