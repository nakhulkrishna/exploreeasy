import 'dart:io';
import 'package:exploreesy/db/db_servies/user_db_servies.dart';
import 'package:exploreesy/db/model/userModel.dart';
import 'package:exploreesy/src/screens/home_screen/home_screen.dart';
import 'package:exploreesy/src/utils/widgets/custome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? imagePath;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (!RegExp(r'^[a-zA-Z0-9]{5,}$').hasMatch(value)) {
      return 'Username must be at least 5 characters long and contain only letters and numbers';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Create your\nProfile in ExploreEase",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ptSerif(fontSize: 26),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: imagePath != null
                          ? FileImage(File(imagePath!))
                          : null, // Display picked image
                      child: imagePath == null
                          ? const Icon(CupertinoIcons.camera, size: 50)
                          : null, // Show camera icon if no image is picked
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Username",
                    ),
                    validator: validateUsername,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Password",
                    ),
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 50),
                  Custome_Button(
                    height: 40,
                    text: "Continue",
                    onpresed: () async {
                      // Check if form is valid
                      if (_formKey.currentState!.validate()) {
                        if (imagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a profile image."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final userdata = Usermodel(
                          username: usernameController.text,
                          password: passwordController.text,
                          profileImagePath: imagePath!,
                        );

                        await addUser(userdata);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
