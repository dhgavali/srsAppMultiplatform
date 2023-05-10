import 'package:shared_preferences/shared_preferences.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'dart:convert';


class AuthLocalStorage {
  static const String _authTokenKey = 'authToken';
  static const String _userKey = 'user';


  Future<void> saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  Future<void> clearAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }
  Future<void> printAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("SharedPreferences: ${prefs.getKeys().map((key) => '$key: ${prefs.get(key)}').join(', ')}");
  }


  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userJson = user.toUserJson();
    await prefs.setString(_userKey, jsonEncode(userJson));
  }


  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    } else {
      return null;
    }
  }


  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('user');
  }


}
