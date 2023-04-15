import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/repositories/AdminRepository.dart';

class UpdateUserUseCase {
  final AdminRepository _adminRepository;

  UpdateUserUseCase(this._adminRepository);

  Future<Result<User?>> call(User user) async {
    return await _adminRepository.updateUser(user);
  }
}
