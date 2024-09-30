import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:exploreesy/db/db_servies/expenseDB_servies.dart';
import 'package:exploreesy/db/db_servies/user_memories_db.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/db/model/user_memories_Model.dart';
import 'package:exploreesy/src/screens/trip_over_review/add_memeris.dart';
import 'package:exploreesy/src/screens/trip_over_review/daily_plan_note.dart/dailypalnner.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:exploreesy/src/utils/widgets/showmodelsheeet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TripOvereviewScreen extends StatefulWidget {
  const TripOvereviewScreen({
    super.key,
    required this.tripModel,
  });

  final TripModel tripModel;

  @override
  State<TripOvereviewScreen> createState() => _TripOvereviewScreenState();
}

class _TripOvereviewScreenState extends State<TripOvereviewScreen> {
  late bool _isSeleceted;

  @override
  void initState() {
    _isSeleceted = widget.tripModel.completed ?? false;

    getExpensesByTripId(widget.tripModel.id);
    super.initState();
  }

  Future<void> _updateTripCompletion(bool isCompleted) async {
    widget.tripModel.completed = isCompleted;
    final tripDB = await Hive.openBox<TripModel>("trip_db");
    await tripDB.put(widget.tripModel.id, widget.tripModel);
    setState(() {
      _isSeleceted = isCompleted;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri lanuchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(lanuchUri)) {
      await launchUrl(lanuchUri);
    } else {
      throw 'Could not lanuch $phoneNumber';
    }
  }

  Widget _infoBox(
      {required IconData icon,
      required String label,
      required Color color,
      void Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getMemories(widget.tripModel.id);
    final DateFormat dateFormat = DateFormat('MMMM dd, yyy');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => DayPlaner(
                        trip: widget.tripModel,
                      )));
            },
            icon: const Icon(Icons.timeline),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          AddMemories(tripdata: widget.tripModel)));
            },
            icon: const Icon(Icons.camera_alt),
          ),
        ],
        centerTitle: true,
        title: Text(
          widget.tripModel.tripName,
          style: GoogleFonts.ptSerif(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        // Use ListView for full scrollability
        padding: const EdgeInsets.all(8.0),
        children: [
          // Image Carousel
          CarouselSlider(
            items: widget.tripModel.photoPaths.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(imageUrl),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              enlargeCenterPage: true,
              height: 200,
              autoPlay: true,
              viewportFraction: 1.0,
              aspectRatio: 16 / 9,
              initialPage: 0,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pageSnapping: true,
            ),
          ),
          const SizedBox(height: 16),

          // Travelers and Budget Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoBox(
                icon: CupertinoIcons.person_2,
                label: "${widget.tripModel.travelersCount} Persons",
                color: AppColors.darkBlue,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        height: 600,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Passengers',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.tripModel.contacts.length,
                                itemBuilder: (context, index) {
                                  final contact =
                                      widget.tripModel.contacts[index];
                                  return ListTile(
                                    onTap: () {
                                      _makePhoneCall(contact['phone']!);
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      contact['name']!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    subtitle: Text(
                                      contact['phone']!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 10),
              _infoBox(
                icon: CupertinoIcons.money_dollar,
                label: "Amount",
                color: Colors.green,
                onTap: () => showBudgetModalSheet(
                    context, widget.tripModel.budget, widget.tripModel.id),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Trip Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      widget.tripModel.tripName,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      "Starting Date ${dateFormat.format(widget.tripModel.startDate)}",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      "Ending Date ${dateFormat.format(widget.tripModel.endDate)}",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      "Budget For This trip ${widget.tripModel.budget}",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.house, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      "Accommodation : ${widget.tripModel.accommodation}",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      activeColor: AppColors.offWhite,
                      activeTrackColor: AppColors.green,
                      value: _isSeleceted,
                      onChanged: (value) async {
                        await _updateTripCompletion(value);
                      },
                    ),
                    Text("COMPLETED"),
                  ],
                ),
              ],
            ),
          ),

          // Memories Section
          const SizedBox(height: 16),
          ValueListenableBuilder(
            valueListenable: UserMemoriesNotifier,
            builder: (context, List<userMemories> value, Widget? child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Memories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Here you can display your memories, for example using a ListView
                    ListView.builder(
                      shrinkWrap:
                          true, // Prevents overflow by taking only the necessary height
                      physics:
                          NeverScrollableScrollPhysics(), // Disable scrolling of this ListView
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        final data = value[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () {},
                                child: Container(
                                  height: 200, // Customize the height as needed
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      // image: AssetImage(data.memoriesPhoto!),
                                      image:
                                          FileImage(File(data.memoriesPhoto!)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ExpandableText(
                                data.caption,
                                trim: 2,
                                trimType: TrimType.lines,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
