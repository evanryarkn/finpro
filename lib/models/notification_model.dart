import 'package:hive/hive.dart';

part 'notification_model.g.dart'; // Pastikan ini ada!

@HiveType(typeId: 1)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final DateTime dateTime;

  NotificationModel({
    required this.title,
    required this.description,
    required this.dateTime,
  });
}
