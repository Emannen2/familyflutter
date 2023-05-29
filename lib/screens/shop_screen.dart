import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Item> items = [];
  bool _isParentLoggedIn = false;

  void addItem() {
    showDialog(
      context: context,
      builder: (ctx) => _isParentLoggedIn
          ? AlertDialog(
              title: Text('Add Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    onChanged: (value) =>
                        setState(() => items.add(Item(title: value))),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Points Needed',
                    ),
                    onChanged: (value) => setState(
                        () => items.last.pointsNeeded = int.parse(value)),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (items.last.title.isNotEmpty &&
                        items.last.pointsNeeded > 0) {
                      Navigator.of(ctx).pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Please enter valid item details',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            )
          : AlertDialog(
              title: Text('Parent Login Required'),
              content: Text('Please log in as a parent to add items.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Close'),
                ),
              ],
            ),
    );
  }

  void buyItem(int index) {
    setState(() => items[index].purchased = true);
  }

  void _parentLogin() {
    showDialog(
      context: context,
      builder: (ctx) => ParentLoginDialog(
        onLogin: (password) {
          if (password == 'Test123') {
            setState(() {
              _isParentLoggedIn = true;
            });
            Navigator.of(ctx).pop();
          } else {
            Fluttertoast.showToast(
              msg: 'Incorrect password',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
      ),
    );
  }

  void _parentLogout() {
    setState(() {
      _isParentLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          IconButton(
            icon: Icon(_isParentLoggedIn ? Icons.logout : Icons.login),
            onPressed: _isParentLoggedIn ? _parentLogout : _parentLogin,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(items[index].title),
          trailing: Text('${items[index].pointsNeeded} pts'),
          tileColor: items[index].purchased ? Colors.green[100] : null,
          onTap: () {
            if (_isParentLoggedIn) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Confirm'),
                  content: Text('Did the child complete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          items[index].purchased = true;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: _isParentLoggedIn
          ? FloatingActionButton(
              onPressed: addItem,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}

class Item {
  String title;
  int pointsNeeded;
  bool purchased;

  Item({required this.title, this.pointsNeeded = 0, this.purchased = false});
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
      content: TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(labelText: 'Password'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onLogin(_passwordController.text);
          },
          child: Text('Login'),
        ),
      ],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShopScreen(),
    );
  }
}
