import 'dart:developer';

import 'package:exploreesy/db/model/userModel.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> addUser(Usermodel value) async {
  final userDB = await Hive.openBox<Usermodel>('user_db');
  await userDB.put('profile', value);

  log(" user name: ${value.username} password : ${value.password}");
}

Future<Usermodel?> gettUser() async {
  final userDB = await Hive.openBox<Usermodel>('user_db');
  final data = await userDB.get("profile");
  log('${data?.username ?? 'User is null'}');
  return data;
}

Future<void> logoutUser() async {
  final userDB = await Hive.openBox<Usermodel>('user_db');
  await userDB.delete('profile'); // This removes the logged-in user's data
  log("User logged out.");
}

Future<bool> isUserLoggedIn() async {
  final userDB = await Hive.openBox<Usermodel>('user_db');
  final user = userDB.get('profile');
  return user != null;
}
