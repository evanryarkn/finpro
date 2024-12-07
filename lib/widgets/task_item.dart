import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String) onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text('${task.dateTime}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(task.id),
      ),
    );
  }
}
