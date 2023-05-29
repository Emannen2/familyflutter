import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred, please try again.';
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use by another account.';
      }
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Registration Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => register(context),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
