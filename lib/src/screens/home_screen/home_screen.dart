import 'package:exploreesy/db/db_servies/db_servies.dart';
import 'package:exploreesy/src/screens/Book_trip/Recent.dart';

import 'package:exploreesy/src/screens/explore_screen/explore_now.dart';
import 'package:exploreesy/src/screens/trip_history/trip_history.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    getAllTrip();

    final pages = [
      const ExploreNowScreen(),
      const RecentTripss(),
      const Trip_History_screen(),
    ];
    ;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Color.fromARGB(255, 202, 240, 248),
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          _onItemTapped(index);
        },
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.location_on),
            label: "Explore Now",
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: "Recent Trip",
          ),
          NavigationDestination(
            icon: Icon(Icons.check),
            label: "Trip History",
          ),
        ],
      ),
    );
  }
}
