import 'dart:io';
import 'package:exploreesy/db/db_servies/user_memories_db.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/db/model/user_memories_Model.dart';
import 'package:exploreesy/src/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMemories extends StatefulWidget {
  final TripModel tripdata;
  const AddMemories({super.key, required this.tripdata});

  @override
  State<AddMemories> createState() => _AddMemoriesState();
}

class _AddMemoriesState extends State<AddMemories> {
  final TextEditingController captionController = TextEditingController();

  String _image = "";

  final picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> imagePicker() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              if (_image.isNotEmpty && captionController.text.isNotEmpty) {
                // Create a userMemories object with the selected image and caption
                final dataofmemorie = userMemories(
                  idOftrip: widget.tripdata.id,
                  caption: captionController.text,
                  memoriesPhoto: _image,
                );
                // Add the memory to the database
                addMemorieTrip(dataofmemorie);
                Navigator.pop(context); // Close the screen after posting
              } else {
                // Show a message if no image is selected or caption is empty
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please add an image and caption.")));
              }
            },
            child: Text(
              "Post",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: AppColors.offblue,
                  ),
                  child: _image.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(_image), // Display the selected image
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.offWhite,
                              child: IconButton(
                                color: AppColors.gray,
                                onPressed: () {
                                  imagePicker();
                                },
                                icon: Icon(CupertinoIcons.add),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text("Add post",
                                style: TextStyle(color: AppColors.gray)),
                          ],
                        ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.offblue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: captionController,
                      minLines: 1,
                      maxLines: null, // TextField will expand vertically
                      decoration: InputDecoration(
                        focusColor: AppColors.darkBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: AppColors.darkBlue),
                        ),
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
