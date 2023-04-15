import 'package:flutter/foundation.dart';
import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/entities/Register.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/UserLoginUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/UserRegisterUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/FetchUserInfoUseCase.dart';

class UserViewModel with ChangeNotifier {
  final UserLoginUseCase _userLoginUseCase;
  final UserRegisterUseCase _userRegisterUseCase;
  final FetchUserInfoUseCase _fetchUserInfoUseCase;

  User? _user;

  UserViewModel({required UserRepository userRepository})
      : _userLoginUseCase = UserLoginUseCaseImpl(userRepository: userRepository),
        _fetchUserInfoUseCase = FetchUserInfoUseCase(userRepository: userRepository),
        _userRegisterUseCase = UserRegisterUseCaseImpl(userRepository: userRepository);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? get user => _user;

  Future<bool> login(String username, String password) async {
    final result = await _userLoginUseCase.call(username, password);
    return result.fold(
          (failure) {
        _errorMessage = failure;
        notifyListeners();
        return false;
      },
          (user) {
        // Set the _user object here
        _user = user;
        notifyListeners();
        return user != null;
      },
    );
  }

  Future<bool> register(Register registerData) async {
    final result = await _userRegisterUseCase.call(registerData);
    return result.fold(
          (failure) {
        _errorMessage = failure;
        notifyListeners();
        return false;
      },
          (_) => true,
    );
  }


  Future<void> fetchUserInfo() async {
    final result = await _fetchUserInfoUseCase.execute();
    result.fold(
          (failure) {
        _errorMessage = failure;
        notifyListeners();
      },
          (user) {
        _user = user;
        notifyListeners();
      },
    );
  }

  bool isAdmin() {
    print("role == : ${_user}");

    return _user?.role == 'admin';
  }
}
