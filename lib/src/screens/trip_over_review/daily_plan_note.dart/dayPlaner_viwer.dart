import 'package:exploreesy/db/db_servies/dayplaner_servies.dart';
import 'package:exploreesy/db/model/Day_planner.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Import the intl package

class DayplanerViwer extends StatefulWidget {
  final TripModel tripdata;
  final int index;

  const DayplanerViwer(
      {super.key, required this.tripdata, required this.index});

  @override
  State<DayplanerViwer> createState() => _DayplanerViwerState();
}

class _DayplanerViwerState extends State<DayplanerViwer> {
  @override
  void initState() {
    super.initState();
    getPlans(widget.tripdata.id, widget.index);
  }

  String formatTime(DateTime time) {
    return DateFormat('kk:mm').format(time); // Format for 24-hour format
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date); // Format for date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Activities'),
      ),
      body: ValueListenableBuilder<List<DayPlanModel>>(
        valueListenable: plansListNotifier,
        builder: (context, plansList, child) {
          if (plansList.isEmpty) {
            return Center(
              child: Text(
                "No daily plans available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: plansList.length,
            itemBuilder: (BuildContext context, int index) {
              final dayPlan = plansList[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: getTileColor(index),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayPlan.plansName!,
                          style: GoogleFonts.ptSerif(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.offWhite),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dayPlan.description!,
                              style: GoogleFonts.ptSerif(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "From: ${formatTime(dayPlan.formTime)}", // Format fromTime
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  "To: ${formatTime(dayPlan.toTime)}", // Format toTime
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  "Date: ${formatDate(dayPlan.date)}", // Format date
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                deletePlans(dayPlan.id);
                              },
                              icon: Icon(CupertinoIcons.delete),
                            ), // Add an icon if needed
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
