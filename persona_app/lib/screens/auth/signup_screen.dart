import 'package:flutter/material.dart';
import '../home/upload_photo_screen.dart'; // Import the upload photo screen
import '../../data/repositories/auth_repository.dart';
import '../../data/datasource/remote/auth_remote_datasource.dart';
import '../../data/datasource/local/auth_local_datasource.dart';
import '../../router/app_router.dart'; // Import the app router
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository(
    AuthRemoteDataSource(),
    AuthLocalDatasource(),
  );
  bool _isLoading = false; // Loading state for sign-up process

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjust padding for keyboard
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20), // Space before image

                // Custom logo image
                Center(
                  child: Image.asset(
                    'assets/images/Frame-2.png', // Image path
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 20),

                // Title "Sign Up"
                Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Username input field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Email input field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Insert Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Password input field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Insert Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password input field
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign Up button
                ElevatedButton(
                  onPressed: _isLoading ? null : _signup, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Login prompt
                GestureDetector(
                  onTap: () {
                    context.go(RouteConstants.loginRoute); // Navigate to login screen
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account?  ',
                          style: TextStyle(
                            color: Color(0xFF110C26),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign in',
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
        ),
      ),
    );
  }

  void _signup() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Passwords do not match.');
      return;
    }

    try {
      final authResponse = await _authRepository.signup(username, email, password, confirmPassword);
      setState(() {
        _isLoading = false; // Stop loading
      });

      // Navigate to the Upload Photo Screen on successful signup
      context.go(RouteConstants.uploadRoute);
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading
      });

      // Show error message
      _showErrorDialog('An error occurred while signing up. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Up Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}