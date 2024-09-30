import 'package:exploreesy/src/screens/home_screen/home_screen.dart';
import 'package:exploreesy/src/screens/onboarding/onborading.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../db/db_servies/user_db_servies.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    bool isLoggedIn = await isUserLoggedIn();

    await Future.delayed(const Duration(seconds: 2));

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ExploreEase",
              style: GoogleFonts.ptSerif(fontSize: 36),
            ),
            Image.asset("assets/images/travelers-concept-illustration.png"),
            SizedBox(
              height: 80,
            ),
            LoadingAnimationWidget.discreteCircle(
                color: AppColors.darkRed, size: 15)
          ],
        ),
      ),
    );
  }
}
