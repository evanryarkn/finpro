import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Future<Box<NotificationModel>> openNotificationBox() async {
    return await Hive.openBox<NotificationModel>('notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<Box<NotificationModel>>(
        future: openNotificationBox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final box = snapshot.data;

          if (box == null || box.isEmpty) {
            return const Center(child: Text('No Notifications'));
          }

          return ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<NotificationModel> notificationsBox, _) {
              return ListView.builder(
                itemCount: notificationsBox.length,
                itemBuilder: (context, index) {
                  final notification = notificationsBox.getAt(index);

                  return ListTile(
                    title: Text(notification?.title ?? 'No Title'),
                    subtitle: Text(
                      '${notification?.description ?? 'No Description'}\n${notification?.dateTime}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => notificationsBox.deleteAt(index),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
