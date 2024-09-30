import 'dart:io';

import 'package:exploreesy/db/db_servies/db_servies.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:exploreesy/src/utils/widgets/custome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Add this import

class EditingScreen extends StatefulWidget {
  final TripModel tripdata;
  const EditingScreen({super.key, required this.tripdata});

  @override
  State<EditingScreen> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _travelersController = TextEditingController();
  final TextEditingController _bagsController = TextEditingController();
  final TextEditingController _amountTotal = TextEditingController();
  final TextEditingController _accommodationController =
      TextEditingController();
  final List<XFile> _imageFiles = []; // List to store selected images
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the trip's existing data
    _tripNameController.text = widget.tripdata.tripName;
    _startDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.tripdata.startDate);
    _endDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.tripdata.endDate);
    _travelersController.text = widget.tripdata.travelersCount.toString();
    _amountTotal.text = widget.tripdata.budget.toString();
    _accommodationController.text = widget.tripdata.accommodation;

    // Preload existing photos
    _imageFiles.addAll(widget.tripdata.photoPaths.map((path) => XFile(path)));
  }

  // Function to pick images
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles);
      });
    }
  }

  // Function to pick a date
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Can be customized
      lastDate: DateTime(2101), // Can be customized
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Build image preview
  Widget _buildImagePreview() {
    return _imageFiles.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            itemCount: _imageFiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return Image.file(File(_imageFiles[index].path));
            },
          )
        : Container(); // Empty container when no images are selected
  }

  // Form validation
  bool _validateForm() {
    if (_tripNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip name cannot be empty')),
      );
      return false;
    }
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select valid start and end dates')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          "Edit Trip",
          style: GoogleFonts.ptSerif(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Your Adventure",
                  style: GoogleFonts.ptSerif(fontSize: 20),
                ),
                Text(
                  "Update your destination, dates, and other details to start planning your trip.",
                  style: GoogleFonts.ptSerif(color: AppColors.gray),
                ),
                const SizedBox(height: 15),
                // Destination
                Row(
                  children: [
                    const Icon(CupertinoIcons.placemark,
                        color: AppColors.darkBlue, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Destination",
                      style: GoogleFonts.ptSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _tripNameController,
                  decoration: InputDecoration(
                    hintText: "Enter trip name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Start Date
                Row(
                  children: [
                    const Icon(CupertinoIcons.calendar,
                        color: AppColors.darkBlue, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Start date",
                      style: GoogleFonts.ptSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onTap: () => _selectDate(context, _startDateController),
                  controller: _startDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Select start date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // End Date
                Row(
                  children: [
                    const Icon(CupertinoIcons.calendar,
                        color: AppColors.darkBlue, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "End date",
                      style: GoogleFonts.ptSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  onTap: () => _selectDate(context, _endDateController),
                  controller: _endDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Select end date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Travelers
                Row(
                  children: [
                    const Icon(CupertinoIcons.person,
                        color: AppColors.darkBlue, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Travelers",
                      style: GoogleFonts.ptSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _travelersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter number of travelers",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Accommodation
                Row(
                  children: [
                    const Icon(CupertinoIcons.building_2_fill,
                        color: AppColors.darkBlue, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Accommodation",
                      style: GoogleFonts.ptSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _accommodationController,
                  decoration: InputDecoration(
                    hintText: "e.g., Hotel, Hostel, Airbnb",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Bags
                Row(
                  children: [
                    const Icon(CupertinoIcons.bag,
                        color: AppColors.darkBlue, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Bags",
                      style: GoogleFonts.ptSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _bagsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter number of bags",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Budget
                Row(
                  children: [
                    const Icon(CupertinoIcons.money_dollar,
                        color: AppColors.darkBlue, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Budget",
                      style: GoogleFonts.ptSerif(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _amountTotal,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter your budget",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 20),
                // Save Button
                Custome_Button(
                  text: "Save Changes",
                  onpresed: () async {
                    if (_validateForm()) {
                      final updatedTrip = TripModel(
                        contacts: widget.tripdata.contacts,
                        id: widget.tripdata.id,
                        tripName: _tripNameController.text,
                        startDate: DateTime.parse(_startDateController.text),
                        endDate: DateTime.parse(_endDateController.text),
                        travelersCount:
                            int.tryParse(_travelersController.text) ?? 0,
                        budget: double.tryParse(_amountTotal.text) ?? 0.0,
                        accommodation: _accommodationController.text,
                        photoPaths:
                            _imageFiles.map((file) => file.path).toList(),
                      );

                      await updateTrip(updatedTrip);
                      Navigator.pop(context); // Go back after saving
                    }
                  },
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
