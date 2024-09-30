import 'package:hive_flutter/hive_flutter.dart';
part 'userModel.g.dart';

@HiveType(typeId: 3)
class Usermodel {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String profileImagePath;

  Usermodel(
      {required this.username,
      required this.password,
      required this.profileImagePath});
}
