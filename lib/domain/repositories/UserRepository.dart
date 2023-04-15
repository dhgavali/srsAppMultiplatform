import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/entities/Register.dart';
import 'package:srsappmultiplatform/core/result.dart';

abstract class UserRepository {
  Future<Result<User?>> login(String username, String password);
  Future<Result<void>> register(Register registerData);

  Future<Result<User>> fetchUserInfo();
}
