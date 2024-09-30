import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/src/screens/trip_over_review/daily_plan_note.dart/dayPlaner_viwer.dart';
import 'package:exploreesy/src/screens/trip_over_review/daily_plan_note.dart/widgets/note_widgets.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayPlaner extends StatefulWidget {
  final TripModel trip;
  const DayPlaner({super.key, required this.trip});

  @override
  State<DayPlaner> createState() => _DayPlanerState();
}

class _DayPlanerState extends State<DayPlaner> {
  List<List<String>> dailyPlans = [];

  void initState() {
    super.initState();
    int tripLength =
        widget.trip.endDate.difference(widget.trip.startDate).inDays + 1;
    dailyPlans = List.generate(tripLength, (_) => []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Planner'),
      ),
      body: ListView.builder(
        itemCount: dailyPlans.length -
            1, // You can adjust this to your dynamic list size
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 0,
            color: getTileColor(index), // Get background color based on index
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DayplanerViwer(
                    index: index,
                    tripdata: widget.trip,
                  ),
                ));
              },
              trailing: IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteWidgets(
                          indexofday: index,
                          tripdata: widget.trip,
                        ),
                      )),
                  icon: Icon(CupertinoIcons.add)),
              title: Text('Day ${index + 1} Plan'), // Title for each tile
            ),
          );
        },
      ),
    );
  }
}
