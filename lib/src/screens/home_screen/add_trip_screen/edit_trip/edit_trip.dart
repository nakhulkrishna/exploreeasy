import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:exploreesy/db/db_servies/db_servies.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:exploreesy/src/utils/widgets/custome_button.dart';
import 'package:exploreesy/src/utils/widgets/edit_trip_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import

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
  Uint8List? webImage;
  final ImagePicker picker = ImagePicker();
  final GlobalKey<FormState> _EditformKey = GlobalKey<FormState>();
  final List<Contact> _isSelectedContacts = [];

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

  Future<void> _pickImages() async {
    if (kIsWeb) {
      // Web image picking - multiple images
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var pickedFile in pickedFiles) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageFiles.add(pickedFile); // Store the XFile object in the list
            // You can store web image bytes here if needed for other purposes
            // webImage = bytes;
          });
        }
      }
    } else {
      // Mobile image picking - multiple images
      final List<XFile>? pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _imageFiles.addAll(pickedFiles); // Add all picked files to the list
        });
      }
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

  Future<void> contacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      _showContactPickerDialog(contacts.toList());
    } else {
      // Show a message that permission was denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact permission is required')),
      );
    }
  }

  void _showContactPickerDialog(List<Contact> contacts) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Contacts"),
          content: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? ''),
                  onTap: () {
                    setState(() {
                      _isSelectedContacts.add(contact);
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
        );
      },
    );
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
    bool isAlphabetic(String value) {
      final RegExp alphabeticRegExp = RegExp(r'^[a-zA-Z\s]+$');
      return alphabeticRegExp.hasMatch(value);
    }

    bool isNumeric(String value) {
      final RegExp numericRegExp = RegExp(r'^\d+$');
      return numericRegExp.hasMatch(value);
    }

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
            child: Form(
              key: _EditformKey,
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
                  edit_trip_form(
                      controller: _tripNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Trip name is required";
                        } else if (!isAlphabetic(value)) {
                          return "Trip name is always  alphabetic";
                        } else if (value.trim().length < 3 ||
                            value.trim().isEmpty) {
                          return "Trip name should be at least 3 characters long";
                        }
                        return null;
                      },
                      hintText: "Enter trip name",
                      keyboardType: TextInputType.name),

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
                  TextFormField(
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
                  TextFormField(
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
                  edit_trip_form(
                      controller: _travelersController,
                      validator: (value) {
                        bool isNumeric(String value) {
                          final RegExp numericRegExp = RegExp(r'^\d+$');
                          return numericRegExp.hasMatch(value);
                        }

                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the number of travelers';
                        } else if (!isNumeric(value)) {
                          return 'Please enter a valid number of travelers';
                        } else if (double.parse(value) <= 0) {
                          return "Please enter valid number of travel at least 1 person";
                        }
                        return null;
                      },
                      hintText: "Enter number of travelers",
                      keyboardType: TextInputType.number),

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

                  edit_trip_form(
                      controller: _accommodationController,
                      validator: (value) {
                        bool isAlphabetic(String value) {
                          final RegExp alphabeticRegExp =
                              RegExp(r'^[a-zA-Z\s]+$');
                          return alphabeticRegExp.hasMatch(value);
                        }

                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter the accommodation type';
                        } else if (!isAlphabetic(value)) {
                          return 'Please enter a valid accommodation type';
                        }
                        return null;
                      },
                      hintText: 'e.g., Hotel, Hostel, Airbnb',
                      keyboardType: TextInputType.name),
                  const SizedBox(height: 10),
                  // Bags
                  Row(
                    children: [
                      const Icon(CupertinoIcons.bag,
                          color: AppColors.darkBlue, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Contacts",
                        style: GoogleFonts.ptSerif(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: contacts,
                    child: const Text("edit Contacts"),
                  ),

                  if (_isSelectedContacts.isNotEmpty)
                    Column(
                      children: _isSelectedContacts.map((contact) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              contact.displayName ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: contact.phones!.map((phone) {
                                return Text(
                                  phone.value ?? 'No phone number',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 10),
                  edit_trip_form(
                      controller: _amountTotal,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a budget';
                        } else if (!isNumeric(value)) {
                          return 'Please enter a valid budget (numeric value)';
                        } else if (double.parse(value) <= 0) {
                          return 'budget must be graterthan Zero';
                        }
                        return null;
                      },
                      hintText: "3000",
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 10),

                  const SizedBox(height: 20),
                  // Save Button
                  Custome_Button(
                    text: "Save Changes",
                    onpresed: () async {
                      if (_EditformKey.currentState!.validate()) {
                        // Merge existing trip contacts with newly selected contacts
                        final List<Map<String, String>> updatedContacts = [
                          ...widget.tripdata.contacts,
                          ..._isSelectedContacts.map((contact) {
                            return {
                              'name': contact.displayName ?? '',
                              'phone': contact.phones?.isNotEmpty == true
                                  ? contact.phones!.first.value ?? ''
                                  : 'No phone',
                            };
                          }).toList(),
                        ];

                        // Create updated trip with merged contacts
                        final updatedTrip = TripModel(
                          TripwebImageBytes: webImage,
                          id: widget.tripdata.id,
                          tripName: _tripNameController.text.trim(),
                          startDate: DateTime.parse(_startDateController.text),
                          endDate: DateTime.parse(_endDateController.text),
                          travelersCount:
                              int.tryParse(_travelersController.text) ?? 0,
                          budget: double.tryParse(_amountTotal.text) ?? 0.0,
                          accommodation: _accommodationController.text.trim(),
                          photoPaths:
                              _imageFiles.map((file) => file.path).toList(),
                          contacts:
                              updatedContacts, // Use the merged contact list
                        );

                        await updateTrip(
                            updatedTrip); // Update the trip in the database
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
      ),
    );
  }
}
