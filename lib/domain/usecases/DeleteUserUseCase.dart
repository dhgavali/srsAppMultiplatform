// lib/domain/usecases/DeleteUserUseCase.dart

import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/repositories/AdminRepository.dart';

class DeleteUserUseCase {
  final AdminRepository _adminRepository;

  DeleteUserUseCase(this._adminRepository);

  Future<Result<bool>> call(String userId) async {
    try {
      await _adminRepository.deleteUser(userId);
      return Result.success(true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
