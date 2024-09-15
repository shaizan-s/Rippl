import 'package:beach1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:beach1/screens/home_screen.dart';  // Update with the actual path to home_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beach Suitability App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),  // Set HomeScreen as the main screen
    );
  }
}
