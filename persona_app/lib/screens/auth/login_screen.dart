import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Import the signup screen
import '../home/upload_photo_screen.dart'; // Import the upload photo screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false; // State for Remember Me toggle
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Loading state for login process

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow the screen to resize when the keyboard is open
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity, // Full width
          padding: EdgeInsets.all(16.0), // Padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60), // Space for keyboard overlay

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
                  hintText: 'Insert Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16), // Space between fields

              // Password input field
              TextField(
                controller: _passwordController,
                obscureText: true, // Hide password input
                decoration: InputDecoration(
                  hintText: 'Insert Password',
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
                  // Add your onPressed logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button color
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white) // Loading indicator
                    : Text(
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
              const SizedBox(height: 40), // Extra space for keyboard visibility
            ],
          ),
        ),
      ),
    );
  }
}