import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/category_selector.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function onDelete;
  final Function onMarkAsDone;

  const TaskItem(
      {super.key,
      required this.task,
      required this.onDelete,
      required this.onMarkAsDone});

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        task.time != null ? task.time!.format(context) : 'No Time';

    return ListTile(
      title: Text(task.title),
      subtitle: Text('${task.category} - $formattedTime'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () =>
                onMarkAsDone(task.id), // Menandai task sebagai selesai
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(task.id),
          ),
        ],
      ),
    );
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedCategory = 'All'; // Kategori yang dipilih

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    // Filter tasks berdasarkan kategori yang dipilih
    final filteredTasks = _selectedCategory == 'All'
        ? tasks
        : tasks.where((task) => task.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Column(
        children: [
          // CategorySelector untuk memilih kategori
          CategorySelector(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (ctx, index) => TaskItem(
                task: filteredTasks[index],
                onDelete: taskProvider.deleteTask,
                onMarkAsDone: taskProvider
                    .markTaskAsDone, // Menambahkan fungsi markAsDone
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, taskProvider),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final titleController = TextEditingController();
    String selectedCategory = 'Work';
    DateTime selectedDate = DateTime.now();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: ['Work', 'Personal', 'Proker']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) selectedCategory = value;
              },
            ),
            TextButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) selectedDate = pickedDate;
              },
              child: const Text('Select Date'),
            ),
            // Menambahkan TimePicker
            TextButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) selectedTime = pickedTime;
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              taskProvider.addTask(
                titleController.text,
                selectedCategory,
                selectedDate,
                selectedTime, // Menambahkan waktu yang dipilih
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
