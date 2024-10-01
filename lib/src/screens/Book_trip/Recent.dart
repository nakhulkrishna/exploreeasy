import 'package:exploreesy/db/db_servies/db_servies.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/src/screens/home_screen/add_trip_screen/add_trips.dart';
import 'package:exploreesy/src/screens/home_screen/add_trip_screen/edit_trip/edit_trip.dart';
import 'package:exploreesy/src/screens/trip_over_review/Trip_overrivew_screen.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RecentTripss extends StatefulWidget {
  const RecentTripss({super.key});

  @override
  State<RecentTripss> createState() => _RecentTripssState();
}

class _RecentTripssState extends State<RecentTripss> {
  @override
  void initState() {
    super.initState();
  }

  // only upcoming trips
  List<TripModel> _getUpcomingTrips(List<TripModel> trips) {
    DateTime now = DateTime.now();
    return trips.where((trip) => trip.startDate.isAfter(now)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Upcoming Trips",
            style: GoogleFonts.ptSerif(),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const AddTripScreen(),
                ));
              },
              icon: const Icon(CupertinoIcons.add),
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: tripListNotifier,
          builder:
              (BuildContext context, List<TripModel> tripList, Widget? child) {
            // Filter the upcoming trips
            List<TripModel> upcomingTrips = _getUpcomingTrips(tripList);

            if (upcomingTrips.isEmpty) {
              return Center(child: Text("No upcoming trips"));
            }

            return ListView.builder(
              itemCount: upcomingTrips.length,
              itemBuilder: (BuildContext context, int index) {
                final data = upcomingTrips[index];
                final String formattedStartDate =
                    DateFormat('MMM dd').format(data.startDate);
                final String formattedEndDate =
                    DateFormat('MM-dd').format(data.endDate);

                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        const SizedBox(width: 5),
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          onPressed: (context) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Confirm"),
                                  content:
                                      Text("Are you sure to delete this trip?"),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.green,
                                        foregroundColor: AppColors.offWhite,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.red,
                                        foregroundColor: AppColors.offWhite,
                                      ),
                                      onPressed: () {
                                        deleteTrip(data);
                                        QuickAlert.show(
                                          confirmBtnColor: AppColors.green,
                                          confirmBtnText: "OK",
                                          context: context,
                                          type: QuickAlertType.success,
                                          title: "Successfully deleted",
                                        );
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: AppColors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        const SizedBox(width: 5),
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          onPressed: (context) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditingScreen(
                                    tripdata: data,
                                  ),
                                ));
                          },
                          backgroundColor: AppColors.darkBlue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.offWhite, // Background color
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => TripOvereviewScreen(
                                        tripModel: data,
                                      )));
                            },
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Starting From $formattedStartDate"),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.all(
                                          Radius.circular(10),
                                        ),
                                        color: AppColors.offblue,
                                      ),
                                      width: 100,
                                      height: 30,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(CupertinoIcons.person),
                                          Text(
                                              " ${data.travelersCount} Persons"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            ),
                            title: Text(
                              data.tripName,
                              style: GoogleFonts.ptSerif(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
