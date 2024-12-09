import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth_model.dart';
import '../../../constant/variables.dart';

class AuthRemoteDataSource {
  // auth_remote_datasource.dart
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login/');
      print('Attempting login with URL: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData == null) {
          throw Exception('Empty response body');
        }
        return AuthResponseModel.fromJson(responseData);
      }

      throw Exception('Login failed with status: ${response.statusCode}');
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<AuthResponseModel> signup(String username, String email,
      String password, String confirm_password) async {
    try {
      final url = Uri.parse('$baseUrl/register/');
      print('Attempting signup with URL: $url');

      final body = {
        'username': username,
        'email': email,
        'password': password,
        'confirm_password': confirm_password,
      };

      print('Request body: ${jsonEncode(body)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Signup failed with status: ${response.statusCode}. Response: ${response.body}');
      }
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    }
  }
}
