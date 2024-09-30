import 'dart:developer';

import 'package:exploreesy/db/model/TripModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<TripModel>> tripListNotifier = ValueNotifier([]);

Future<void> addTrip(TripModel value) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  await tripDB.put(value.id, value); // Use the trip's id as the key
  tripListNotifier.value.add(value);
  tripListNotifier.notifyListeners();
}

Future<void> getAllTrip() async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  tripListNotifier.value.clear();
  tripListNotifier.value
      .addAll(tripDB.values); // Add all trip objects to the notifier

  for (var trip in tripDB.values) {
    log('Trip ID: ${trip.id}');
    log('Trip Name: ${trip.tripName}');
    log('Start Date: ${trip.startDate}');
    log('End Date: ${trip.endDate}');
    log('Persons: ${trip.travelersCount}');
    log('contacts : ${trip.contacts}');
    log('Budget: ${trip.budget}');
    log('Photo Paths: ${trip.photoPaths}');
    log('Status: ${trip.completed ? 'Completed' : 'Not Completed'}');
    log('---'); // Separator for clarity
  }

  tripListNotifier.notifyListeners();
}

Future<void> deleteTrip(TripModel trip) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  await tripDB.delete(trip.id);
  await getAllTrip();
}

Future<void> updateTrip(TripModel updatedTrip) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  await tripDB.put(updatedTrip.id, updatedTrip); // Update the existing trip
  log("updated ${updatedTrip.id}");
  await getAllTrip(); // Refresh the trip list
}

Future<void> markTripAsCompleted(TripModel trip) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  trip.completed = true;
  await tripDB.put(trip.id, trip);
  log("trip ${trip.id} marked as completed");
  await getAllTrip();
}

Future<void> markTripAsNotCompleted(TripModel trip) async {
  final tripDB = await Hive.openBox<TripModel>('trip_db');
  trip.completed = false;
  await tripDB.put(trip.id, trip);
  log("trip ${trip.id} marked as completed");
  await getAllTrip();
}
