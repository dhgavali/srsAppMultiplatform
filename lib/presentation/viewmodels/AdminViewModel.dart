// lib/presentation/viewmodels/admin_viewmodel.dart

import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/usecases/DeleteUserUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/FetchUsersByRoleUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/UpdateUserUseCase.dart';

class AdminViewModel {
  final FetchUsersByRoleUseCase _fetchUsersByRoleUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  AdminViewModel(
      this._fetchUsersByRoleUseCase,
      this._updateUserUseCase,
      this._deleteUserUseCase,
      );

  Future<List<User>> fetchUsersByRole(String role) async {
    final result = await _fetchUsersByRoleUseCase.call(role);
    return result.fold(
          (failure) => throw Exception(failure),
          (users) => users,
    );
  }

  Future<User?> updateUser(User user) async {
    final result = await _updateUserUseCase.call(user);
    return result.fold(
          (failure) => throw Exception(failure),
          (updatedUser) => updatedUser,
    );
  }

  Future<bool> deleteUser(String userId) async {
    final result = await _deleteUserUseCase.call(userId);
    return result.fold(
          (failure) => throw Exception(failure),
          (_) => true,
    );
  }
}
