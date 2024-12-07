import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../models/notification_model.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  final Map<DateTime, List<Task>> _tasksByDate = {};
  final List<Task> _completedTasks = []; // Daftar task yang sudah selesai

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

  // Menambahkan task baru
  void addTask(String title, String category, DateTime date, TimeOfDay? time) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      category: category,
      dateTime: date,
      time: time,
    );
    _tasks.add(newTask);

    // Menambahkan task ke dalam _tasksByDate
    final taskDate = DateTime(date.year, date.month, date.day);
    _tasksByDate.putIfAbsent(taskDate, () => []).add(newTask);

    // Menyimpan notifikasi
    _addNotification(
      'Task Added',
      'Task "$title" has been added to $category category.',
    );

    notifyListeners();
  }

  // Mendapatkan tasks berdasarkan tanggal
  List<Task> getTasksForDate(DateTime date) {
    final taskDate = DateTime(date.year, date.month, date.day);
    return _tasksByDate[taskDate] ?? [];
  }

  // Menandai task sebagai selesai
  void markTaskAsDone(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks.removeAt(taskIndex);
      task.isCompleted = true;
      _completedTasks.add(task);

      // Menghapus task dari _tasksByDate
      final taskDate =
          DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);
      _tasksByDate[taskDate]?.removeWhere((t) => t.id == taskId);

      // Menyimpan notifikasi
      _addNotification(
        'Task Completed',
        'Task "${task.title}" has been marked as done.',
      );

      notifyListeners();
    }
  }

  // Menghapus task
  void deleteTask(String taskId) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks.removeAt(taskIndex);

      final taskDate =
          DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);
      _tasksByDate[taskDate]?.removeWhere((t) => t.id == taskId);

      _addNotification(
          'Task Deleted', 'Task "${task.title}" has been deleted.');
      notifyListeners();
    } else {
      _addNotification('Error', 'Task with ID $taskId not found.');
    }
  }

  // Menyimpan notifikasi ke Hive
  void _addNotification(String title, String description) {
    final notificationBox = Hive.box<NotificationModel>('notifications');
    final notification = NotificationModel(
      title: title,
      description: description,
      dateTime: DateTime.now(),
    );
    notificationBox.add(notification);
  }
}
