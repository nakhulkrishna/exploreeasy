import 'dart:developer';

import 'package:exploreesy/db/model/user_memories_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

ValueNotifier<List<userMemories>> UserMemoriesNotifier = ValueNotifier([]);

Future<void> addMemorieTrip(userMemories value) async {
  final memoriesDB = await Hive.openBox<userMemories>('UserMemories_DB');
  await memoriesDB.put(value.id, value);
  UserMemoriesNotifier.value.add(value);
  await getMemories(value.idOftrip);
  UserMemoriesNotifier.notifyListeners();
}

Future<void> getMemories(String tripId) async {
  final memoriesDB = await Hive.openBox<userMemories>('UserMemories_DB');
  UserMemoriesNotifier.value.clear();

  List<userMemories> filterMemorie =
      memoriesDB.values.where((memorie) => memorie.idOftrip == tripId).toList();
  log("trip id of memorie filter == ${tripId}");
  UserMemoriesNotifier.value.addAll(filterMemorie);

  for (var elements in filterMemorie) {
    log("caption = ${elements.caption}");
    log("Id = ${elements.id}");
    log("tripID = ${elements.idOftrip}");
    log("PhotoPath = ${elements.memoriesPhoto}");
  }
  UserMemoriesNotifier.notifyListeners();
}
