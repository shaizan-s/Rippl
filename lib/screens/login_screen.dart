import 'package:flutter/material.dart';
import 'package:beach1/screens/home_screen.dart'; // The tourist home screen
import 'package:beach1/screens/local_guard_home.dart'; // The local guard screen

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BeachMap()),
                );
              },
              child: Text('Tourist'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalGuardHomeScreen()),
                );
              },
              child: Text('Local/Coastal Guard'),
            ),
          ],
        ),
      ),
    );
  }
}
