import 'package:get_it/get_it.dart';
import 'package:srsappmultiplatform/data/datasources/remote/remote_data_source.dart';
import 'package:srsappmultiplatform/data/repositories/user_repositoryImpl.dart';
import 'package:srsappmultiplatform/data/datasources/auth_local_storage.dart';
import 'package:srsappmultiplatform/data/repositories/admin_repository_Impl.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/AdminViewModel.dart';
import 'package:srsappmultiplatform/domain/usecases/FetchUsersByRoleUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/UpdateUserUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/DeleteUserUseCase.dart';
import 'package:srsappmultiplatform/domain/usecases/FetchUserInfoUseCase.dart';

final getIt = GetIt.instance;


void setupServiceLocator() {
  // Register AuthLocalStorage first
  getIt.registerSingleton<AuthLocalStorage>(AuthLocalStorage());

  // Then register RemoteDataSource
  getIt.registerSingleton<RemoteDataSource>(RemoteDataSource(authLocalStorage: getIt<AuthLocalStorage>()));

  getIt.registerSingleton<UserRepositoryImpl>(
    UserRepositoryImpl(
      remoteDataSource: getIt<RemoteDataSource>(),
      authLocalStorage: getIt<AuthLocalStorage>(),
    ),
  );

  getIt.registerFactory<AdminViewModel>(
        () => AdminViewModel(
      getIt<FetchUsersByRoleUseCase>(),
      getIt<UpdateUserUseCase>(),
      getIt<DeleteUserUseCase>(),
    ),
  );

  getIt.registerSingleton<AdminRepositoryImpl>(
    AdminRepositoryImpl(remoteDataSource: getIt<RemoteDataSource>()),
  );

  getIt.registerFactory<FetchUsersByRoleUseCase>(
        () => FetchUsersByRoleUseCase(getIt<AdminRepositoryImpl>()),
  );

  getIt.registerFactory<UpdateUserUseCase>(
        () => UpdateUserUseCase(getIt<AdminRepositoryImpl>()),
  );

  getIt.registerFactory<DeleteUserUseCase>(
        () => DeleteUserUseCase(getIt<AdminRepositoryImpl>()),
  );

  getIt.registerFactory<FetchUserInfoUseCase>(
        () => FetchUserInfoUseCase(userRepository: getIt<UserRepositoryImpl>()),
  );


}
