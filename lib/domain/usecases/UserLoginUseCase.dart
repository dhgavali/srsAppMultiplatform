import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';
import 'package:srsappmultiplatform/core/result.dart';

abstract class UserLoginUseCase {
  Future<Result<User?>> call(String username, String password);
}

class UserLoginUseCaseImpl implements UserLoginUseCase {
  final UserRepository userRepository;

  UserLoginUseCaseImpl({required this.userRepository});

  @override
  Future<Result<User?>> call(String username, String password) async {
    return await userRepository.login(username, password);
  }

}

