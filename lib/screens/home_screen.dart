import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user?.email}!'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/tasks'),
              child: Text('Tasks'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/shop'),
              child: Text('Shop'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
