import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // Import the login screen
import 'screens/splash_screen.dart'; // Import the splash screen
import 'screens/home/upload_photo_screen.dart'; // Import the upload photo screen
import 'screens/auth/signup_screen.dart'; // Import the signup screen
import 'screens/recommendation/editscreen.dart'; // Import the edit screen
import 'screens/classify/genderselectionscreen.dart'; // Import the gender selection screen
import 'screens/profile/profile_screen.dart'; // Import the profile screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persona App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color theme
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adaptive density
      ),
      initialRoute: '/', // Set the initial route
        routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/upload': (context) => UploadPhotoScreen(),
        '/signup': (context) => SignupScreen(),
        '/gender_selection': (context) => GenderSelectionScreen(),
        '/edit': (context) => EditScreen(),
        '/profile': (context) => ProfileScreen(), // Consistent naming
      },
      debugShowCheckedModeBanner: false, // Disable debug banner
    );
  }
}