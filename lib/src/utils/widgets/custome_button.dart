import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/material.dart';

class Custome_Button extends StatelessWidget {
  final VoidCallback onpresed;
  final double height;
  final String text;
  const Custome_Button({
    super.key,
    required this.onpresed,
    required this.text,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(double.infinity, height),
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.offWhite,
        ),
        onPressed: onpresed,
        child: Text(text),
      ),
    );
  }
}
