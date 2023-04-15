import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';

class FetchUserInfoUseCase {
  final UserRepository _userRepository;

  FetchUserInfoUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  Future<Result<User>> execute() async {
    return _userRepository.fetchUserInfo();
  }
}
