import 'package:flutter/material.dart';
import 'dart:io' as io;

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  io.File? _dummyFile;

  @override
  void initState() {
    super.initState();
    _dummyFile = io.File('assets/images/dummy_photo.jpg'); // Ensure this file exists.
  }

  void _navigateToGenderSelection() {
    if (_dummyFile != null) {
      Navigator.pushNamed(
        context,
        '/gender_selection',
        arguments: {'file': _dummyFile},
      );
    } else {
      print('No image selected.');
    }
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to LoginScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img-main1.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _navigateToLoginScreen, // Navigate to LoginScreen
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _navigateToLoginScreen, // Navigate to LoginScreen
                      child: const Text(
                        "Hello, Guest!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Recognize your",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Personality",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 172, 200),
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Reveal your true style with personalized recommendations for hairstyles, accessories, and more, tailored just for you",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _navigateToGenderSelection, // Navigate to GenderSelectionScreen
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: const Color(0xFF92A5FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Select Photo',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}