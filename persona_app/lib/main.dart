import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import the login screen
import 'screens/splash_screen.dart'; // Import the splash screen
import 'screens/upload_photo_screen.dart'; // Import the upload photo screen

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
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => SplashScreen(), // The splash screen as the initial screen
        '/upload': (context) => UploadPhotoScreen(), // Route to the upload photo screen
        // Add other routes as needed
      },
    );
  }
}