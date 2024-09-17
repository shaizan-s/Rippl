import 'package:flutter/material.dart';
import 'package:beach1/screens/home_screen.dart'; // The tourist home screen
import 'package:beach1/screens/local_guard_home.dart'; // The local guard screen


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/bg.png', // Path to your background image
            fit: BoxFit.cover,
          ),
          // Login buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoginButton(
                  context,
                  'Tourist',
                  Icons.explore,
                  Colors.blueAccent,
                  Colors.white,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BeachMap()),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildLoginButton(
                  context,
                  'Local/Coastal Guard',
                  Icons.security,
                  Colors.greenAccent,
                  Colors.white,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocalGuardHomeScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context,
      String text,
      IconData icon,
      Color backgroundColor,
      Color textColor,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
