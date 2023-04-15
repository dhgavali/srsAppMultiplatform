import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/repositories/AdminRepository.dart';

class FetchUsersByRoleUseCase {
  final AdminRepository _adminRepository;

  FetchUsersByRoleUseCase(this._adminRepository);

  Future<Result<List<User>>> call(String role) async {
    return await _adminRepository.fetchUsersByRole(role);
  }
}
