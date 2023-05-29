import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  int _totalPoints = 0;
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
    _totalPoints = _tasks.fold(
        0, (sum, task) => sum + (task.isCompleted ? task.points : 0));

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
                              });
                              Navigator.of(ctx).pop();
                            },
                            child: Text('Mark as Done'),
                          ),
                        ],
                      ),
                    );
                  },
                  leading: task.imageUrl != null
                      ? SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.file(File(task.imageUrl!)),
                        )
                      : null,
                  title: Text(task.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.description),
                      Text('Points: ${task.points}'),
                    ],
                  ),
                  trailing: task.isCompleted
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isParentLoggedIn
            ? () {
                showDialog(
                  context: context,
                  builder: (ctx) => TaskDialog(
                    onTaskAdded: _addTask,
                  ),
                );
              }
            : null,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  final int points;
  final String title;
  final String description;
  bool isCompleted;
  String? imageUrl;

  Task({
    required this.points,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.imageUrl,
  });
}

class TaskDialog extends StatefulWidget {
  final void Function(Task) onTaskAdded;

  TaskDialog({required this.onTaskAdded});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pointsController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _pointsController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final points = int.parse(_pointsController.text);
      final title = _titleController.text;
      final description = _descriptionController.text;

      final newTask = Task(
        points: points,
        title: title,
        description: description,
        imageUrl: _selectedImage?.path,
      );

      widget.onTaskAdded(newTask);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _pointsController,
              decoration: InputDecoration(labelText: 'Points'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the points';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 2,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the description';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Select Image'),
            ),
            if (_selectedImage != null) Image.file(_selectedImage!),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Add Task'),
        ),
      ],
    );
  }
}

class ParentLoginDialog extends StatefulWidget {
  final void Function(String) onLogin;

  ParentLoginDialog({required this.onLogin});

  @override
  _ParentLoginDialogState createState() => _ParentLoginDialogState();
}

class _ParentLoginDialogState extends State<ParentLoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final password = _passwordController.text;
      widget.onLogin(password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Parent Login'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter the password';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Login'),
        ),
      ],
    );
  }
}
