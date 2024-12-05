import '../datasource/auth_remote_datasource.dart';
import '../datasource/auth_local_datasource.dart';
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

  Future<AuthResponseModel> signup(String fullName, String email, String password) async {
    final authResponse = await authRemoteDataSource.signup(fullName, email, password);
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
}