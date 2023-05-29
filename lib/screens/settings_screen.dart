import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signed out successfully.'),
      ),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void changePassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: FirebaseAuth.instance.currentUser!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A password reset link has been sent to your email.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred, please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Change Password'),
            onTap: () => changePassword(context),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () => signOut(context),
          ),
        ],
      ),
    );
  }
}
