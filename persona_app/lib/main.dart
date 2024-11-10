import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import the login screen
import 'screens/splash_screen.dart'; // Import the splash screen
import 'screens/upload_photo_screen.dart'; // Import the upload photo screen
import 'screens/signup_screen.dart'; // Import the signup screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persona App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/upload': (context) => UploadPhotoScreen(),
        '/signup': (context) => SignupScreen(), // Add sign-up route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}