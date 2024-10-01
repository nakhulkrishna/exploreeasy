import 'dart:developer';

import 'package:exploreesy/db/model/Day_planner.dart';
import 'package:exploreesy/db/model/expenseModel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<DayPlanModel>> plansListNotifier = ValueNotifier([]);
Future<void> addDailyPlan(DayPlanModel value) async {
  final dailyPlanDB = await Hive.openBox("DailyPlan_DB");

  await dailyPlanDB.put(value.id, value);
  log(
    """
    Added Daily Plan:
    - Date: ${value.date}
    - Plan Name: ${value.plansName}
    - Description: ${value.description}
    - From Time: ${value.formTime}
    - To Time: ${value.toTime}
    - Dayplan id :  ${value.id}

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
    return plan.Tripid == tripId && plan.indexofday == indexOfDay;
  }).toList();

  // Update the notifier list with the filtered plans
  plansListNotifier.value = filteredPlans;
  plansListNotifier.notifyListeners();
}

Future<void> deletePlans(String DayplanId) async {
  final dailyPlanDB = await Hive.openBox("DailyPlan_DB");

  // Log current keys before checking
  log('Current Daily Plans Keys: ${dailyPlanDB.keys.toList()}',
      name: 'Daily Plan Logger');

  // Check if the plan exists before attempting to delete
  final exists = dailyPlanDB.containsKey(DayplanId);

  if (exists) {
    await dailyPlanDB.delete(DayplanId);
    log('Deleted Daily Plan with ID: $DayplanId', name: 'Daily Plan Logger');
  } else {
    log('No Daily Plan found with ID: $DayplanId', name: 'Daily Plan Logger');
  }

  // Optional: Log the current state of the database
  log('Current Daily Plans: ${dailyPlanDB.keys.toList()}',
      name: 'Daily Plan Logger');
}
