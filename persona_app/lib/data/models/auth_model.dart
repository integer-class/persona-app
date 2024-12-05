class AuthResponseModel {
  final String status;
  final String message;
  final AuthData data;

  AuthResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        status: json['status'],
        message: json['message'],
        data: AuthData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class AuthData {
  final String token;
  final int userId;
  final String email;

  AuthData({
    required this.token,
    required this.userId,
    required this.email,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        token: json['token'],
        userId: json['userId'],
        email: json['email'],
  );

  Map<String, dynamic> toJson() => {
        'token': token,
        'userId': userId,
        'email': email,
      };
}

class RegisterData {
  final UserData user;
  final String token;

  RegisterData({
    required this.user,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
    user: UserData.fromJson(json['user']),
    token: json['token'],
  );

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'token': token,
  };
}

class UserData {
  final int id;
  final String username;
  final String email;

  UserData({
    required this.id,
    required this.username, 
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json['id'],
    username: json['username'],
    email: json['email'], 
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
  };
}
