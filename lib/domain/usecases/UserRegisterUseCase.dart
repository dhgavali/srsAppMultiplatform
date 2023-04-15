import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/Register.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';

abstract class UserRegisterUseCase {
  Future<Result<void>> call(Register registerData);
}

class UserRegisterUseCaseImpl implements UserRegisterUseCase {
  final UserRepository userRepository;

  UserRegisterUseCaseImpl({required this.userRepository});

  @override
  Future<Result<void>> call(Register registerData) async {
    return await userRepository.register(registerData);
  }
}
