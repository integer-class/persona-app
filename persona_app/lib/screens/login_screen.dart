import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Import the signup screen
import 'upload_photo_screen.dart'; // Import the upload photo screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false; // State for Remember Me toggle
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Full width
        height: double.infinity, // Full height
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16.0), // Padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Custom logo image
            Center(
              child: Image.asset(
                'assets/images/Frame-2.png', // Image path
                width: 120, // Adjust the width as needed
                height: 120, // Adjust the height as needed
              ),
            ),
            const SizedBox(height: 20), // Space between image and title

            // Title "Sign in"
            Text(
              'Sign in',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30), // Space between title and fields

            // Email input field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'abc@email.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Space between fields

            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true, // Hide password input
              decoration: InputDecoration(
                hintText: 'Your password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Space between fields

            // Remember Me toggle switch
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value;
                    });
                  },
                ),
                Text(
                  'Remember Me',
                  style: TextStyle(
                    color: Color(0xFF110C26),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30), // Space between switch and button

            // Sign In button
            ElevatedButton(
              onPressed: () {
                // Handle sign-in logic here
                Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UploadPhotoScreen()),
    );
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button color
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between button and sign up prompt

            // Sign Up prompt
            GestureDetector(
              onTap: () {
                // Navigate to the signup screen
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don’t have an account?  ',
                      style: TextStyle(
                        color: Color(0xFF110C26),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: Color(0xFFFFA1BF),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}