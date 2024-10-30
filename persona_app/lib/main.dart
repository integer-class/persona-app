import 'package:flutter/material.dart';
import 'screens/onboarding.dart'; // Import the onboarding screen
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set scaffold background to white
      ),
      home: SplashScreen(), // Set splash screen as the initial screen
    );
  }
}