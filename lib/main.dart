import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Add this import for the login screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beach App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Set the initial screen to the LoginScreen
    );
  }
}
