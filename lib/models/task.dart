import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String category;
  final DateTime dateTime;
  final TimeOfDay? time; // Menambahkan waktu sebagai TimeOfDay
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    this.time, // Menambahkan waktu sebagai parameter opsional
    this.isCompleted = false,
  });
}
