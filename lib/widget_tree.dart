import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => FirebaseAuth.instance.currentUser != null
            ? HomeScreen()
            : LoginScreen(),
        '/register': (ctx) => RegisterScreen(),
        '/forgot-password': (ctx) => ForgotPasswordScreen(),
        '/home': (ctx) => HomeScreen(),
        '/tasks': (ctx) => TaskScreen(),
        '/shop': (ctx) => ShopScreen(),
        '/settings': (ctx) => SettingsScreen(),
      },
    );
  }
}
