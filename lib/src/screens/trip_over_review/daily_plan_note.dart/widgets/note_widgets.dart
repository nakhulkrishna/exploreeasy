import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import 'package:exploreesy/db/db_servies/dayplaner_servies.dart';
import 'package:exploreesy/db/model/Day_planner.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/src/utils/widgets/costome_textfield.dart';

class NoteWidgets extends StatefulWidget {
  final TripModel tripdata;
  final int indexofday;

  const NoteWidgets({
    super.key,
    required this.tripdata,
    required this.indexofday,
  });

  @override
  _NoteWidgetsState createState() => _NoteWidgetsState();
}

class _NoteWidgetsState extends State<NoteWidgets> {
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _transportationController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getPlans(widget.tripdata.id, widget.indexofday);
    super.initState();
  }

  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      // Format the time as a string
      String formattedTime = selectedTime.format(context);
      // Set the selected time to the controller
      controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Check for valid time entries
                if (_fromTimeController.text.isEmpty ||
                    _toTimeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Both From time and To time are required.")),
                  );
                  return;
                }

                final DateFormat formatter = DateFormat('hh:mm a');
                DateTime? fromTime;
                DateTime? toTime;

                try {
                  fromTime = formatter.parse(_fromTimeController.text);
                  toTime = formatter.parse(_toTimeController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Invalid time format. Please use hh:mm AM/PM.")),
                  );
                  return;
                }

                // Validate time logic
                if (!toTime.isAfter(fromTime)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("To time must be after From time.")),
                  );
                  return; // Prevent saving if validation fails
                }

                final data = DayPlanModel(
                  transportaion: _transportationController.text,
                  formTime: fromTime,
                  toTime: toTime,
                  description: _description.text,
                  indexofday: widget.indexofday,
                  id: widget.tripdata.id,
                  plansName: _activityController.text,
                  date: DateTime.now(),
                );

                addDailyPlan(data);
                // Optionally, navigate back or show a success message here
              }

              Navigator.of(context).pop();
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
        backgroundColor: Colors.white,
        title: Text(
          'Plan Your Day',
          style: GoogleFonts.ptSerif(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              // Activity input field
              Custome_TextFieldd(
                validator: (value) {
                  bool isAlphabetic(String value) {
                    final RegExp alphabeticRegExp = RegExp(r'^[a-zA-Z\s]+$');
                    return alphabeticRegExp.hasMatch(value);
                  }

                  if (value == null || value.trim().isEmpty) {
                    return "Activity name is required";
                  } else if (value.trim().length < 3) {
                    return "Activity name length must be 6 or more";
                  } else if (value.trim().length > 25) {
                    return "Activity name length must be less than 25";
                  } else if (!isAlphabetic(value)) {
                    return "Activity name cannot contain numbers or symbols";
                  }
                  return null;
                },
                labelText: 'Enter Activity',
                hintText: 'e.g., Breakfast at Hotel',
                controller: _activityController,
              ),

              const SizedBox(height: 20),

              Custome_TextFieldd(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Description is required";
                  } else if (value.trim().length < 6) {
                    return "Description length must be 6 or more";
                  }
                  return null;
                },
                labelText: 'Description',
                hintText: 'e.g., Brief explanation',
                controller: _description,
              ),
              const SizedBox(height: 20),
              // Time picker fields
              Row(
                children: [
                  Expanded(
                    child: Custome_TextFieldd(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "From time is required";
                        }
                        return null;
                      },
                      labelText: 'From time',
                      hintText: 'Activity time',
                      controller: _fromTimeController,
                      onTap: () => _selectTime(_fromTimeController),
                    ),
                  ),
                  const SizedBox(width: 10), // Add space between fields
                  Expanded(
                    child: Custome_TextFieldd(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "To time is required";
                        }
                        return null;
                      },
                      labelText: 'To time',
                      hintText: 'Activity time',
                      controller: _toTimeController,
                      onTap: () => _selectTime(_toTimeController),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Custome_TextFieldd(
                validator: (value) {
                  bool isAlphabetic(String value) {
                    final RegExp alphabeticRegExp = RegExp(r'^[a-zA-Z\s]+$');
                    return alphabeticRegExp.hasMatch(value);
                  }

                  if (value == null || value.trim().isEmpty) {
                    return "Transportation is required";
                  } else if (!isAlphabetic(value)) {
                    return "Transportation name cannot contain numbers or symbols";
                  } else if (value.trim().length < 3) {
                    return "Activity description length must be 6 or more";
                  }
                  return null;
                },
                labelText: "Transportation",
                hintText: "e.g., Car or bus",
                controller: _transportationController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
