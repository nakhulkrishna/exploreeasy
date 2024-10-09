import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:exploreesy/db/db_servies/db_servies.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:exploreesy/src/utils/widgets/addtripForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../../utils/widgets/custome_button.dart'; // For date formatting

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _travelersController = TextEditingController();
  final TextEditingController _amountTotal = TextEditingController();
  final TextEditingController _accommodationController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _imageFiles = []; // List to store selected images
  Uint8List? webImage;
  final ImagePicker picker = ImagePicker();
  final List<Contact> _isSelectedContacts = [];

  Future<void> _pickImages() async {
    final List<XFile> pickedImage = await picker.pickMultiImage();

    if (kIsWeb) {
      for (var picked in pickedImage) {
        webImage = await picked.readAsBytes();

        final image = base64Encode(webImage!.toList());
        _imageFiles.add(image);
      }
    } else {
      for (var pickedpic in pickedImage) {
        _imageFiles.add(pickedpic.path);
      }
    }

    setState(() {});
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

  // Function to pick a date
  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      DateTime? initialDate,
      DateTime? currentDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate:
          currentDate ?? DateTime.now(), // Start date can't be before today
      lastDate: DateTime(2101), // Can be customized
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          "Create Trip",
          style: GoogleFonts.ptSerif(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Plan Your Next Adventure",
                    style: GoogleFonts.ptSerif(fontSize: 20),
                  ),
                  Text(
                    "Enter your destination, dates, and other details to start planning your trip.",
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
                  AddTripForm(
                      keyboardType: TextInputType.name,
                      controller: _tripNameController,
                      validator: (value) {
                        bool isAlphabetic(String value) {
                          final RegExp alphabeticRegExp =
                              RegExp(r'^[a-zA-Z\s]+$');
                          return alphabeticRegExp.hasMatch(value);
                        }

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
                      hintText: "e.g, Paris or Canada"),
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
                    onTap: () => _selectDate(
                        context, _startDateController, null, DateTime.now()),
                    controller: _startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "e.g., 2024-09-10",
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
                    onTap: () {
                      final startDate =
                          DateTime.tryParse(_startDateController.text);
                      _selectDate(
                          context,
                          _endDateController,
                          startDate, // Ensure end date is after start date
                          DateTime.now());
                    },
                    controller: _endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "e.g., 2024-09-10",
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
                  AddTripForm(
                    keyboardType: TextInputType.number,
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
                    controller: _travelersController,
                    hintText: "e.g, 2",
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
                  AddTripForm(
                    keyboardType: TextInputType.text,
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
                    controller: _accommodationController,
                    hintText: "e.g, Taj Hotel or Royal Hotels",
                  ),
                  const SizedBox(height: 10),
                  // Bags
                  Row(
                    children: [
                      const Icon(CupertinoIcons.phone,
                          color: AppColors.darkBlue, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Partners Phone Number",
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
                    child: const Text("Add Contacts"),
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
                  AddTripForm(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      bool isNumeric(String value) {
                        final RegExp numericRegExp = RegExp(r'^\d+$');
                        return numericRegExp.hasMatch(value);
                      }

                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a budget';
                      } else if (!isNumeric(value)) {
                        return 'Please enter a valid budget (numeric value)';
                      } else if (double.parse(value) <= 0) {
                        return 'budget must be graterthan Zero';
                      }
                      return null;
                    },
                    controller: _amountTotal,
                    hintText: "e.g, ₹4000",
                  ),
                  const SizedBox(height: 10),
                  // Image Picker
                  Row(
                    children: [
                      const Icon(CupertinoIcons.photo,
                          color: AppColors.darkBlue, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        "Photos",
                        style: GoogleFonts.ptSerif(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _pickImages,
                        child: Text('Add Photos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Display picked images
                  if (_imageFiles.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageFiles.length,
                        itemBuilder: (context, index) {
                          final imageFile = _imageFiles[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: kIsWeb
                                ? Image.memory(
                                    base64Decode(imageFile),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(imageFile),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 10),
                  Custome_Button(
                    onpresed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_imageFiles.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please add at least one image for the trip')),
                          );
                          return;
                        }

                        final List<Map<String, String>> selectedContacts =
                            _isSelectedContacts.map((contact) {
                          final String name = contact.displayName ?? "Unknown";
                          final String phoneNumber = contact.phones!.isNotEmpty
                              ? contact.phones!.first.value ?? "No phone Number"
                              : "No phone Number";
                          return {
                            'name': name,
                            'phone': phoneNumber,
                          };
                        }).toList();

                        final DateTime? startDate =
                            DateTime.tryParse(_startDateController.text);
                        final DateTime? endDate =
                            DateTime.tryParse(_endDateController.text);

                        if (startDate != null &&
                            endDate != null &&
                            startDate.isBefore(endDate)) {
                          final addNewTrip = TripModel(
                            TripwebImageBytes: webImage,
                            contacts: selectedContacts,
                            tripName: _tripNameController.text.trim(),
                            startDate: startDate,
                            endDate: endDate,
                            travelersCount: int.tryParse(
                                    _travelersController.text.trim()) ??
                                0,
                            accommodation: _accommodationController.text.trim(),
                            budget: double.tryParse(_amountTotal.text) ?? 0.0,
                            photoPaths: _imageFiles
                                .map((imageFile) => imageFile)
                                .toList(),
                          );

                          addTrip(addNewTrip);
                          Navigator.pop(context); // Close the screen
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Please enter valid start and end dates')),
                          );
                        }
                      }
                    },
                    text: "Create Trip",
                    height: 50,
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
