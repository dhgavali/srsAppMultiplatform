import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/entities/Register.dart';
import 'package:srsappmultiplatform/data/datasources/auth_local_storage.dart';

class RemoteDataSource {
  final String _baseUrl = "http://192.168.0.150:3001";
  final AuthLocalStorage _authLocalStorage;

  final headers = {
    'Content-Type': 'application/json',
  };

  RemoteDataSource({required AuthLocalStorage authLocalStorage})
      : _authLocalStorage = authLocalStorage ?? AuthLocalStorage();

  Future<Map<String, String>> get _headers async {
    String token = await _authLocalStorage.getAuthToken() ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> register(Register registerData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/signup'),
      headers: headers,
      body: jsonEncode({
        'fullName': registerData.username,
        'email': registerData.email,
        'password': registerData.password,
        'phone': registerData.phone,
        'dateOfBirth': registerData.birthday,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user ${response.body}');
    }
  }

  Future<Result<User>> login(String username, String password) async {
    try {
      final body = jsonEncode({
        'email': username,
        'password': password,
      });

      print("login ${username}  ${password}");
      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/login'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        final jsonResponse = jsonDecode(response.body);

        // Extract the token and role from the parsed JSON
        String token = jsonResponse['data']['token'];
        String? role = jsonResponse['data']['user']['role'];

        // Create a UserData object from the parsed JSON
        User user = User.fromJson(jsonResponse['data']['user']);

        // Update the User object with the fetched token and role
        user = user.copyWith(token: token, role: role);

        return Result.success(user);
      } else {
        // If the call fails, return a Result with the error message
        return Result.failure('Failed to login ${response.body}');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
  Future<Result<List<User>>> getUsersByRole(String role) async {
    try {
      final token = await _authLocalStorage.getAuthToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users?role=$role'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> usersJson = jsonResponse['data']['users'];
        List<User> users = usersJson.map((json) => User.fromJson(json)).toList();

        return Result.success(users);
      } else {
        return Result.failure(
            'Failed to fetch users with role $role ${response.body}');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }



  Future<Result<User?>> updateUser(User user) async {
    try {
      final token = await _authLocalStorage.getAuthToken();
      final response = await http.put(
        Uri.parse('$_baseUrl/api/users/${user.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fullName': user.username,
          'email': user.email,
          'phone': user.phone,
          'dateOfBirth': user.dateOfBirth,
          'role': user.role,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Result.success(User.fromJson(jsonResponse));
      } else {
        return Result.failure('Failed to update user ${user.id}');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> deleteUser(String userId) async {
    try {
      final token = await _authLocalStorage.getAuthToken();
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Result.success(true);
      } else {
        return Result.failure('Failed to delete user $userId');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }


  Future<Result<User>> getUserInfo() async {
    try {
      final token = await _authLocalStorage.getAuthToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final user = User.fromJson(jsonResponse);
        return Result.success(user);
      } else {
        return Result.failure('Failed to fetch user information');
      }
    } catch (e) {
      return Result.failure('Failed to fetch user information: $e');
    }
  }


}









