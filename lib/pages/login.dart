import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:familyapp/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Family App');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: title,
          labelStyle: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _entryFieldPass(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      obscureText: true,
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white,
        labelText: title,
        labelStyle: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
      child: Text(errorMessage == '' ? '' : 'Humm ? $errorMessage',
          style: const TextStyle(color: Colors.redAccent),
          textAlign: TextAlign.center),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3ABFA9),
        elevation: 0,
        disabledBackgroundColor: Colors.grey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _loginOrRegistrationButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[300],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFDDBD1),
      body: SafeArea(
        top: true,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Image.asset(
                  'images/logo2.png',
                  scale: 1.9,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Color(0xFFF1F6F9),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Icon(
                                FontAwesomeIcons.lock,
                                size: 30,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 100),
                              _entryField(
                                ' Email',
                                _controllerEmail,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 25.0, 20),
                                child: _entryFieldPass(
                                  ' Password',
                                  _controllerPassword,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            _errorMessage(),
                            const SizedBox(height: 10),
                            _submitButton(),
                            const SizedBox(height: 30),
                            _loginOrRegistrationButton(),
                            const SizedBox(height: 90),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFfb9191),
                                elevation: 0,
                                disabledBackgroundColor: Colors.grey,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              ),
                              onPressed: () {
                                debugPrint('Login button clicked');
                              },
                              child: const Text(
                                'Forgot password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
