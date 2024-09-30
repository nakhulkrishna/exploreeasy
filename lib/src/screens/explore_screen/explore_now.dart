import 'package:exploreesy/src/screens/home_screen/add_trip_screen/add_trips.dart';
import 'package:exploreesy/src/screens/home_screen/profile_screen/profile_screen.dart';
import 'package:exploreesy/src/utils/widgets/all_trip_list_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreNowScreen extends StatefulWidget {
  const ExploreNowScreen({super.key});

  @override
  State<ExploreNowScreen> createState() => _ExploreNowScreenState();
}

class _ExploreNowScreenState extends State<ExploreNowScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "ExploreEase",
            style: GoogleFonts.ptSerif(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const AddTripScreen(),
                ));
              },
              icon: const Icon(CupertinoIcons.add),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const ProfileScreen(),
                ));
              },
              icon: const Icon(CupertinoIcons.person),
            ),
          ],
        ),
        body: AllTripList());
  }
}
