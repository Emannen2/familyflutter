import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class UserProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              // Replace with the user's profile picture
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
            SizedBox(height: 16.0),
             Text(
              'UsersName',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
           Text(
            '${user?.email}!',
              style: TextStyle(fontSize: 16.0, color: Color.fromARGB(109, 61, 61, 61)),
            ),
            SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: () {
              },
            ),
             ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () => changePassword(context),
          ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Change Email'),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Account'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
