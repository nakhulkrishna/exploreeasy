import 'dart:io';
import 'package:exploreesy/db/db_servies/user_db_servies.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/db/model/userModel.dart';
import 'package:exploreesy/src/screens/settings/Help_screen.dart';
import 'package:exploreesy/src/screens/settings/Terms_screen.dart';
import 'package:exploreesy/src/screens/settings/about_us_screen.dart';
import 'package:exploreesy/src/screens/settings/privacy_screen.dart';
import 'package:exploreesy/src/utils/widgets/ettings_container.dart';
import 'package:exploreesy/src/screens/onboarding/Profile_creating/profile_creating.dart'; // Onboarding screen
import 'package:exploreesy/src/utils/widgets/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<TripModel> trip = [];
  @override
  void initState() {
    loaduser();

    super.initState();
  }

  Usermodel? userdata;

  String appVersion = '';

  void loaduser() async {
    userdata = await gettUser();
    setState(() {});
  }

  void deleteImage(int index) {
    setState(() {
      // Assuming you update your list of memories in the database here
      // Add logic to delete from the actual Hive storage
      // Example: remove memory from UserMemoriesNotifier or Hive
    });
  }

  Future<void> _logout() async {
    await logoutUser(); // Remove user data from Hive
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileCreateScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    Custome_Button(
                      onpresed: () {
                        _logout(); // Call the logout function
                      },
                      text: "Log Out",
                      height: 40,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
        centerTitle: true,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: GoogleFonts.ptSerif(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 50,
                      backgroundImage: userdata != null
                          ? MemoryImage(userdata!.webImageBytes!)
                          : const AssetImage("assets/images/profile.png")),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userdata?.username ?? 'No Username',
                        style: GoogleFonts.ptSerif(fontSize: 18),
                      ),
                      Text(
                        userdata != null
                            ? 'Logged in as: ${userdata!.username}'
                            : '',
                        style: GoogleFonts.ptSerif(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              Row(
                children: [
                  Text(
                    "Settings",
                    style: GoogleFonts.ptSerif(fontSize: 30),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              setteings_container(
                ontap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PrivacyScreen(),
                  ));
                },
                icons: Icons.privacy_tip_outlined,
                title: 'Privacy And Polices',
              ),
              SizedBox(
                height: 10,
              ),
              setteings_container(
                ontap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TermsAndServices(),
                  ));
                },
                icons: Icons.gavel_outlined,
                title: "Terms of Service",
              ),
              SizedBox(
                height: 10,
              ),
              setteings_container(
                ontap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HelpScreen(),
                  ));
                },
                icons: Icons.help,
                title: 'Help And Support',
              ),
              SizedBox(
                height: 10,
              ),
              setteings_container(
                ontap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutUsScreen(),
                  ));
                },
                icons: Icons.info,
                title: 'About us',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
