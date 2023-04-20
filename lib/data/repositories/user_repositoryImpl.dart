import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/data/datasources/auth_local_storage.dart';
import 'package:srsappmultiplatform/data/datasources/remote/remote_data_source.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/domain/entities/Register.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';

class UserRepositoryImpl extends UserRepository {
  final RemoteDataSource _remoteDataSource;
  final AuthLocalStorage _authLocalStorage;

  UserRepositoryImpl({
    required RemoteDataSource remoteDataSource,
    required AuthLocalStorage authLocalStorage,
  })   : _remoteDataSource = remoteDataSource,
        _authLocalStorage = authLocalStorage;

  @override
  Future<Result<User?>> login(String username, String password) async {
    try {
      final userResult = await _remoteDataSource.login(username, password);

      if (userResult.isFailure) {
        print("Login failure: ${userResult.failure}");

        return Result.failure(userResult.failure);
      }

      final user = userResult.success;
      print("token: ${user.token}");

      await _authLocalStorage.saveAuthToken(user.token);

      print("Login success: ${user.exerciseLevel?.toJson()?.toString()}");

      return Result.success(user);
    } catch (e) {
      print("Login error: $e");

      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> register(Register registerData) async {
    try {
      await _remoteDataSource.register(registerData);
      return Result.success(true);
    } on Exception catch (e) {
      return Result.failure(e.toString());
    }
  }


  @override
  Future<Result<User>> fetchUserInfo() async {
    try {
      final result = await _remoteDataSource.getUserInfo();
      return result;
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // ...


  }






