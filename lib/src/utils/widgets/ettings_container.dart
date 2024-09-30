import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/material.dart';

class setteings_container extends StatelessWidget {
  final IconData icons;
  final String title;
  final VoidCallback ontap;

  const setteings_container({
    super.key,
    required this.icons,
    required this.title,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(icons),
            SizedBox(
              width: 10,
            ),
            Text(title)
          ],
        ),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.offWhite, borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
