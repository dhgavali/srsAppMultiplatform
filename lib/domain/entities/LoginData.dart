import 'dart:convert';

class LoginData {
  final User user;
  final String token;
  final int statusCode;

  LoginData({required this.user, required this.token, required this.statusCode});

  factory LoginData.fromJson(Map<String, dynamic> jsonMap) {
    return LoginData(
      user: User.fromJson(jsonMap['user']),
      token: jsonMap['token'],
      statusCode: jsonMap['statusCode'],
    );
  }
}