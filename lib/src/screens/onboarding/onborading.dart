import 'package:exploreesy/src/screens/onboarding/Profile_creating/profile_creating.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/widgets/custome_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  // Onboarding data
  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/travelers-concept-illustration.png',
      'text':
          'Your travel made simple. Discover new destinations and plan your trips.',
      'subtitle': 'Discover new destinations and plan your trips.',
    },
    {
      'image': 'assets/images/design-inspiration-concept-illustration.png',
      'text': 'Experience hassle-free travel planning with our app.',
      'subtitle': 'With our app, planning your trips is a breeze.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      return OnBoarding(
                        showButton: index == onboardingData.length - 1,
                        images: onboardingData[index]['image']!,
                        text: onboardingData[index]['text']!,
                        subtitle: onboardingData[index]['subtitle']!,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: onboardingData.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: AppColors.darkBlue,
                      activeDotColor: AppColors.lightBlue,
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: TextButton(
                onPressed: () {
                  // Navigate to ProfileCreateScreen when skip is pressed
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const ProfileCreateScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.ptSerif(
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoarding extends StatelessWidget {
  final String images;
  final String text;
  final bool showButton;
  final String subtitle;

  const OnBoarding({
    super.key,
    required this.images,
    required this.text,
    this.showButton = false,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            images,
            height: 500,
          ),
          const Spacer(),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.ptSerif(
              textStyle: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 8), // Add spacing between title and subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.ptSerif(
              textStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Spacer(),
          if (showButton) // Show button conditionally
            Custome_Button(
              height: 40,
              text: "Continue",
              onpresed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const ProfileCreateScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
