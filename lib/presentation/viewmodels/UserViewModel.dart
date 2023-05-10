import 'package:flutter/foundation.dart';
import 'package:srsappmultiplatform/core/di/service_locator.dart';
import 'package:srsappmultiplatform/domain/entities/Register.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';
import 'package:srsappmultiplatform/domain/repositories/WorkoutPlanRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/FetchCompletedWorkoutPlansUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/FetchUserInfoUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/FetchWorkoutPlansByUserIdUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/UserLoginUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/CheckTheTokenExpiredUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/UserRegisterUseCase.dart';
import 'package:srsappmultiplatform/data/datasources/auth_local_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:srsappmultiplatform/core/di/service_locator.dart';

class UserViewModel with ChangeNotifier {
  final UserLoginUseCase _userLoginUseCase;
  final CheckTheTokenExpiredUseCase _checkTheTokenExpiredUseCase;
  final UserRegisterUseCase _userRegisterUseCase;
  final FetchUserInfoUseCase _fetchUserInfoUseCase;
  final FetchCompletedWorkoutPlansUseCase _fetchCompletedWorkoutPlansUseCase;
  final FetchWorkoutPlansByUserIdUseCase _fetchWorkoutPlansByUserIdUseCase;
  AuthLocalStorage authLocalStorage = getIt<AuthLocalStorage>();
  UserRepository userRepository = getIt<UserRepository>();

  ValueNotifier<User?> userNotifier = ValueNotifier(null);


  UserViewModel(
      {required UserRepository userRepository, required WorkoutPlanRepository workoutPlanRepository})
      : _userLoginUseCase = UserLoginUseCaseImpl(
      userRepository: userRepository),
        _fetchUserInfoUseCase = FetchUserInfoUseCase(
            userRepository: userRepository),
        _userRegisterUseCase = UserRegisterUseCaseImpl(
            userRepository: userRepository),
        _fetchWorkoutPlansByUserIdUseCase = FetchWorkoutPlansByUserIdUseCase(
            workoutPlanRepository: workoutPlanRepository),
        _fetchCompletedWorkoutPlansUseCase = FetchCompletedWorkoutPlansUseCase(
            workoutPlanRepository: workoutPlanRepository),
        _checkTheTokenExpiredUseCase = CheckTheTokenExpiredUseCase(
            userRepository: userRepository);


  User? _user;

  User? get user => _user;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<WorkoutPlan> _workoutPlans = [];

  List<WorkoutPlan> get workoutPlans => _workoutPlans;

  List<WorkoutPlan> _completedWorkoutPlans = [];

  List<WorkoutPlan> get completedWorkoutPlans => _completedWorkoutPlans;


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
        if (user == null) {
          print("userViewModel");
        }
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

  Future<void> fetchWorkoutPlansByUserId(String userId) async {
    final result = await _fetchWorkoutPlansByUserIdUseCase.call(userId);
    result.fold(
          (failure) {
        _errorMessage = failure;
        notifyListeners();
      },
          (workoutPlans) {
        _workoutPlans = workoutPlans;
        notifyListeners();
      },
    );
  }

  Future<void> fetchCompletedWorkoutPlans(String userId) async {
    print("UserViewModel userId $userId");
    final result = await _fetchCompletedWorkoutPlansUseCase.call(userId);
    result.fold(
          (failure) {
        _errorMessage = failure;
        print("UserViewModel failure $failure");
        notifyListeners();
      },
          (completedWorkoutPlans) {
        authLocalStorage.printAll();

        _completedWorkoutPlans = completedWorkoutPlans;
        print("UserViewModel result $_completedWorkoutPlans");
        notifyListeners();
      },
    );
  }

  Future<void> logout() async {
    // Clear workout plans
    workoutPlans.clear();
    // Clear the bearer token from shared preferences
await authLocalStorage.deleteUser();
    await authLocalStorage.printAll();
    await authLocalStorage.clearAuthToken();
  }
  Future<void> checkTheTokenExpired(Function(String) onRoleFetched) async {
    print("UserViewModel checkTheTokenExpired");
    final result = await _checkTheTokenExpiredUseCase.call();

    result.fold((failure) {
      print("UserViewModel $failure");
      _errorMessage = failure;
    }, (role) {
      print("UserViewModel $role");
      onRoleFetched(role);
    });
  }

  Future<void> getValidUser() async {
    final user = userRepository.getValidUser();
    userNotifier.value = await user;
  }




}

