import 'dart:convert';
import 'package:persona_app/data/models/auth_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  final _secureStorage = FlutterSecureStorage();

  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    // Convert the Map<String, dynamic> to a JSON String
    await _secureStorage.write(key: 'auth_data', value: json.encode(authResponseModel.toJson()));
  }

  Future<void> removeAuthData() async {
    //remove auth data from secure storage
    await _secureStorage.delete(key: 'auth_data');
  }

  Future<AuthResponseModel?> getAuthData() async {
    //get auth data from secure storage
    final authData = await _secureStorage.read(key: 'auth_data');
    if (authData != null) {
      // Convert the JSON String back to Map and then to the AuthResponseModel object
      return AuthResponseModel.fromJson(json.decode(authData));
    } else {
      return null;
    }
  }

  Future<bool> isAuth() async {
    //check if user is authenticated
    final authData = await _secureStorage.read(key: 'auth_data');
    return authData != null;
  }
}