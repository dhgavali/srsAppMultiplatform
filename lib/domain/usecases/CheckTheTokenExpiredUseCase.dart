import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/usecase.dart';

class CheckTheTokenExpiredUseCase implements UseCase<String, void> {
  final UserRepository userRepository;

  CheckTheTokenExpiredUseCase({required this.userRepository});

  @override
  Future<Result<String>> call([void params]) async {
    print("CheckTheTokenExpiredUseCase ${ await userRepository.checkTheTokenExpired()}");

    return await userRepository.checkTheTokenExpired();
  }
}
