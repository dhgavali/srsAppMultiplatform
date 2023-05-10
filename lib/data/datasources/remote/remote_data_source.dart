import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // This import is needed for SocketException and HttpException
import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/entities/Register.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:srsappmultiplatform/data/datasources/auth_local_storage.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
class RemoteDataSource {
  final String _baseUrl = "http://192.168.0.150:3001";
  final AuthLocalStorage _authLocalStorage;

  late IO.Socket _socket;

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
await _authLocalStorage.printAll();
        // Extract the token and role from the parsed JSON
        String token = jsonResponse['data']['token'];
        String? role = jsonResponse['data']['user']['role'];

        // Create a UserData object from the parsed JSON
        User user = User.fromJson(jsonResponse['data']['user']);

        // Update the User object with the fetched token and role
        user = user.copyWith(token: token, role: role);
        await _authLocalStorage.saveUser(user);

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
        await _authLocalStorage.saveUser(user);
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

  Future<Result<List<WorkoutPlan>>> fetchWorkoutPlansByUserId(String userId) async {
    try {
      print("$_baseUrl/api/users/user-workout-plans?userid=${userId}");
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/user-workout-plans?userId=$userId'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> workoutPlansJson = jsonResponse['data']['workoutplans']; // Change 'workoutPlans' to 'workoutplans'
        final List<WorkoutPlan> workoutPlans = workoutPlansJson.map((json) => WorkoutPlan.fromJson(json)).toList();
        print("fetchworkout ${workoutPlans}");
        return Result.success(workoutPlans);
      } else {
        print("fetchworkout failed ${response.body}");
        return Result.failure('Failed to fetch workout plans for user $userId');
      }
    } catch (e) {
      print("fetchworkout failed ${e}");
      return Result.failure(e.toString());
    }
  }


  Future<Result<List<WorkoutPlan>>> fetchCompletedWorkoutPlans(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/user-workout-plans?userid=$userId&completed=true'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        print("response Workout userId:$userId ${response.body.toString()}");
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> workoutPlansJson = jsonResponse['data']['workoutPlans'];
        final List<WorkoutPlan> workoutPlans = workoutPlansJson.map((json) => WorkoutPlan.fromJson(json)).toList();

        return Result.success(workoutPlans);
      } else {
        return Result.failure('Failed to fetch completed workout plans for user $userId');
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
  Future<Result<String>> checkTheTokenExpired() async {
    try {
      final token = await _authLocalStorage.getAuthToken();
      if (token == null) {
        print("Token is null");
        return Result.failure('Token not found');
      }
      print("Sending HTTP GET request to check token expiration...");
      final response = await http.get(
        Uri.parse('$_baseUrl/api/users/check-token-expiration'),
        headers: await _headers,
      );
print("ResponseToken ${response.body.toString()}");
      if (response.statusCode == 400) {
        print("Token format is incorrect or not provided");
        return Result.failure("No token provided or token format is incorrect");
      } else if (response.statusCode == 401) {
        print("Token expired. Login again");
        return Result.failure("Token expired. Login again");
      } else if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final String role = jsonResponse['data']['role']; // Assuming the server returns the role as 'role' key in the JSON response.
        print("Token is still valid. Role: $role");
        return Result.success(role);
      }

      print("Unexpected error occurred");
      return Result.failure("Unexpected error occurred");
    } on SocketException {
      print("No Internet connection");
      return Result.failure("No Internet connection");
    } on HttpException {
      print("Couldn't reach the server");
      return Result.failure("Couldn't reach the server");
    } on FormatException {
      print("Bad response format");
      return Result.failure("Bad response format");
    } catch (e) {
      print("An error occurred: $e");
      return Result.failure(e.toString());
    }
  }


 void initSocket() {
    _socket = IO.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on('connect', (_) {
      print('Connected to Socket.IO server');
    });

    _socket.on('disconnect', (_) => print('Disconnected from Socket.IO server'));

    // Add event listeners for trainer request updates here

    _socket.connect();
  }

}









