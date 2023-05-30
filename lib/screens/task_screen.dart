import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'points.dart';

void main() {
  runApp(FamilyApp());
}

class FamilyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _tasks = [
    Task(
      points: 10,
      title: 'Clean Room',
      description: 'Clean and organize the room',
    ),
    Task(
      points: 5,
      title: 'Wash Dishes',
      description: 'Wash the dishes and clean the sink',
    ),
    Task(
      points: 15,
      title: 'Take out the Trash',
      description: 'Empty all the trash bins in the house',
    ),
  ];

  int _totalPoints = Points.totalPoints;
  bool _isParentLoggedIn = false;

  void _addTask(Task newTask) {
    setState(() {
      _tasks.add(newTask);
    });
  }

  void _loginAsParent(String password) {
    if (password == 'Test123') {
      setState(() {
        _isParentLoggedIn = true;
      });
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Logged in as Parent');
    } else {
      Fluttertoast.showToast(msg: 'Invalid password');
    }
  }

  void _logoutAsParent() {
    setState(() {
      _isParentLoggedIn = false;
    });
    Fluttertoast.showToast(msg: 'Logged out');
  }

  @override
  Widget build(BuildContext context) {
    _totalPoints = Points.totalPoints;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          if (!_isParentLoggedIn)
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => ParentLoginDialog(
                    onLogin: _loginAsParent,
                  ),
                );
              },
            ),
          if (_isParentLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logoutAsParent,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total Points: $_totalPoints'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (ctx, index) {
                final task = _tasks[index];
                return ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Confirm Task Completion'),
                        content: Text(
                            'Are you sure you want to mark this task as done?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                task.isCompleted = true;
                                Points.totalPoints += task.points;
                              });
                              Navigator.of(ctx).pop();
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        task.isCompleted = value ?? false;
                      });
                    },
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Text('${task.points} pts'),
                );
              },
            ),
          ),
          if (_isParentLoggedIn)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AddTaskDialog(
                      onAddTask: _addTask,
                    ),
                  );
                },
                child: Text('Add Task'),
              ),
            ),
        ],
      ),
    );
  }
}

class Task {
  final int points;
  final String title;
  final String description;
  bool isCompleted;

  Task({
    required this.points,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class ParentLoginDialog extends StatefulWidget {
  final Function(String password) onLogin;

  ParentLoginDialog({required this.onLogin});

  @override
  _ParentLoginDialogState createState() => _ParentLoginDialogState();
}

class _ParentLoginDialogState extends State<ParentLoginDialog> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Parent Login'),
      content: TextField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final password = _passwordController.text;
            widget.onLogin(password);
          },
          child: Text('Login'),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(Task newTask) onAddTask;

  AddTaskDialog({required this.onAddTask});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _pointsController,
            decoration: InputDecoration(labelText: 'Points'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text;
            final description = _descriptionController.text;
            final points = int.tryParse(_pointsController.text) ?? 0;

            if (title.isNotEmpty && description.isNotEmpty && points > 0) {
              final newTask = Task(
                points: points,
                title: title,
                description: description,
              );

              widget.onAddTask(newTask);
              Navigator.of(context).pop();
            } else {
              Fluttertoast.showToast(
                msg: 'Please enter valid values for all fields',
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}