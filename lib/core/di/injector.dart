import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:star_drive/features/auth/data/dataresource/auth_remote_datasource.dart';
import 'package:star_drive/features/auth/data/repository/auth_repositories_impl.dart';
import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';
import 'package:star_drive/features/auth/domain/usecase/login_use_case.dart';
import 'package:star_drive/features/auth/domain/usecase/register_use_case.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';

import '../network/dio_client.dart';


final sl = GetIt.instance;

void setupDependencies() {
  // Shared HTTP client
  sl.registerLazySingleton<Dio>(
    () => DioClient().dio,
  );

  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<Dio>()),
  );

  // Repository implementation
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
    ),
  );

  // Use case
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(
      sl<AuthRepository>(),
    ),
  );
sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      sl<AuthRepository>(),
    ),
  );

  // A new BLoC instance for each provider
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      registerUser: sl<RegisterUser>(),
    ),

  );
   sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl<LoginUseCase>() ),
  );
}