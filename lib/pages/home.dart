import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:familyapp/auth.dart';
import 'package:familyapp/pages/analytics.dart';
import 'package:familyapp/pages/tasks.dart';
import 'package:familyapp/pages/shop.dart';
import 'package:familyapp/pages/settings.dart';
import 'package:familyapp/pages/warehouse.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  int _currentIndex = 0;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign out'),
    );
  }

  List<Widget> _screens() {
    return [
      // Home screen
      TasksPage(),

      // Shop screen
      ParentShop(),

      // Analysis screen
      AnalyticsPage(),

      // Settings screen
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDDBD1),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFDDBD1),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tasks',
            backgroundColor: Color(0xFFFDDBD1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
            backgroundColor: Color(0xFFFDDBD1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
            backgroundColor: Color(0xFFFDDBD1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color(0xFFFDDBD1),
          ),
        ],
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            _currentIndex == 0
                ? 'Tasks'
                : _currentIndex == 1
                    ? 'Shop'
                    : _currentIndex == 2
                        ? 'Analysis'
                        : 'Settings',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFFDDBD1),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens(),
      ),
    );
  }
}
