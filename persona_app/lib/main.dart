import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import the login screen
import 'screens/splash_screen.dart'; // Import the splash screen
import 'screens/login_screen.dart'; // Import the onboarding screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Ensure this is set to your splash screen
    );
  }
}