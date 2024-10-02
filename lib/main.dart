import 'dart:async';
import 'package:exploreesy/db/model/Day_planner.dart';
import 'package:exploreesy/db/model/TripModel.dart';
import 'package:exploreesy/db/model/expenseModel.dart';
import 'package:exploreesy/db/model/userModel.dart';
import 'package:exploreesy/db/model/user_memories_Model.dart';

import 'package:exploreesy/src/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TripModelAdapter().typeId)) {
    Hive.registerAdapter(TripModelAdapter());
  }
  if (!Hive.isAdapterRegistered(ExpenseModelAdapter().typeId)) {
    Hive.registerAdapter(ExpenseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(UsermodelAdapter().typeId)) {
    Hive.registerAdapter(UsermodelAdapter());
  }
  if (!Hive.isAdapterRegistered(DayPlanModelAdapter().typeId)) {
    Hive.registerAdapter(DayPlanModelAdapter());
  }
  if (!Hive.isAdapterRegistered(userMemoriesAdapter().typeId)) {
    Hive.registerAdapter(userMemoriesAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ExploreEasy',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
