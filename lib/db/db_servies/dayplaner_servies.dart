import 'dart:developer';

import 'package:exploreesy/db/model/Day_planner.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<DayPlanModel>> plansListNotifier = ValueNotifier([]);
Future<void> addDailyPlan(DayPlanModel value) async {
  final dailyPlanDB = await Hive.openBox("DailyPlan_DB");

  await dailyPlanDB.add(value);
  log(
    """
    Added Daily Plan:
    - Date: ${value.date}
    - Plan Name: ${value.plansName}
    - Description: ${value.description}
    - From Time: ${value.formTime}
    - To Time: ${value.toTime}
    """,
    name: 'Daily Plan Logger',
  );

  plansListNotifier.notifyListeners();
}

Future<void> getPlans(String tripId, int indexOfDay) async {
  final dailyPlanDB = await Hive.openBox("DailyPlan_DB");

  // Get all plans from the Hive box
  final allPlans = dailyPlanDB.values.toList().cast<DayPlanModel>();

  // Filter the plans by tripId and indexOfDay
  List<DayPlanModel> filteredPlans = allPlans.where((plan) {
    return plan.id == tripId && plan.indexofday == indexOfDay;
  }).toList();

  // Update the notifier list with the filtered plans
  plansListNotifier.value = filteredPlans;
  plansListNotifier.notifyListeners();
}
