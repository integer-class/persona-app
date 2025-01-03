import '../datasource/remote/auth_remote_datasource.dart';
import '../datasource/local/auth_local_datasource.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDatasource authLocalDatasource;

  AuthRepository(this.authRemoteDataSource, this.authLocalDatasource);

  Future<AuthResponseModel> login(String email, String password) async {
    final authResponse = await authRemoteDataSource.login(email, password);
    await authLocalDatasource.saveAuthData(authResponse);
    return authResponse;
  }

  Future<AuthResponseModel> signup(String username, String email,
      String password, String confirm_password) async {
    final authResponse = await authRemoteDataSource.signup(
        username, email, password, confirm_password);
    await authLocalDatasource.saveAuthData(authResponse);
    return authResponse;
  }

  Future<void> logout() async {
    await authLocalDatasource.removeAuthData();
  }

  Future<AuthResponseModel?> getAuthData() async {
    return await authLocalDatasource.getAuthData();
  }

  Future<bool> isAuth() async {
    return await authLocalDatasource.isAuth();
  }

  Future<AuthResponseModel?> getProfile() async {
    try {
      final profile = await authRemoteDataSource.getProfile();
      await authLocalDatasource.saveAuthData(profile); // Update local data
      return profile;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }
}
