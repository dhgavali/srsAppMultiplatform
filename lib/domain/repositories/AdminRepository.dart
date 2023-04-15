// lib/domain/repositories/admin_repository.dart
import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';

abstract class AdminRepository {
  Future<Result<List<User>>> fetchUsersByRole(String role);
  Future<Result<User?>> updateUser(User user);
  Future<Result<void>> deleteUser(String userId);
}
