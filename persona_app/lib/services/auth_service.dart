import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<bool> login(String email, String password) async {
    // Hardcoded credentials for demonstration purposes
    if (email == 'bismillahselesai@gmail.com' && password == '123456') {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'), // Replace with your API endpoint
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Sign-up successful
      } else {
        return false; // Sign-up failed
      }
    } catch (e) {
      return false; // Handle exceptions
    }
  }
}