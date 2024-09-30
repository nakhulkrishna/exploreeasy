import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'user_memories_Model.g.dart';

@HiveType(typeId: 5)
class userMemories {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String idOftrip;
  @HiveField(2)
  final String caption;

  @HiveField(3)
  final String? memoriesPhoto;

  userMemories(
      {required this.idOftrip,
      required this.caption,
      required this.memoriesPhoto})
      : id = Uuid().v4();
}
