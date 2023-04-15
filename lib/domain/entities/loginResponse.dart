import 'dart:convert';

class LoginResponse {
  final String status;
  final LoginData data;

  LoginResponse({required this.status, required this.data});

  factory LoginResponse.fromJson(String jsonString) {
    final jsonMap = json.decode(jsonString);
    return LoginResponse(
      status: jsonMap['status'],
      data: LoginData.fromJson(jsonMap['data']),
    );
  }
}
