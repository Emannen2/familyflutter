import 'package:flutter/material.dart';
import 'package:familyapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:familyapp/auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDDBD1),
      body: Center(
        child: _signOutButton(),
      ),
    );
  }
}
