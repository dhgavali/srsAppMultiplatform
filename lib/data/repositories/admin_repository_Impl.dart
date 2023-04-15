// lib/data/repositories/admin_repository_impl.dart

import 'package:srsappmultiplatform/data/datasources/remote/remote_data_source.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/repositories/AdminRepository.dart';
import 'package:srsappmultiplatform/core/result.dart';

class AdminRepositoryImpl extends AdminRepository {
  final RemoteDataSource _remoteDataSource;

  AdminRepositoryImpl({required RemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<User>>> fetchUsersByRole(String role) async {
    try {
      final usersResult = await _remoteDataSource.getUsersByRole(role);
      return usersResult;
    } catch (e) {
      return Result.failure('Error fetching users by role: ${e.toString()}');
    }
  }

  @override
  Future<Result<User?>> updateUser(User user) async {
    try {
      final updatedUserResult = await _remoteDataSource.updateUser(user);
      return updatedUserResult;
    } catch (e) {
      return Result.failure('Error updating user: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> deleteUser(String userId) async {
    try {
      await _remoteDataSource.deleteUser(userId);
      return Result.success(null);
    } catch (e) {
      return Result.failure('Error deleting user: ${e.toString()}');
    }
  }
}
