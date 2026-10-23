import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/dataresource/auth_remote_datasource.dart';
import 'package:star_drive/features/auth/data/repository/auth_repositories_impl.dart';
import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';
import 'package:star_drive/features/auth/domain/usecase/login_use_case.dart';
import 'package:star_drive/features/auth/domain/usecase/register_use_case.dart';
import 'package:star_drive/features/auth/domain/usecase/reset_password_usecase.dart';
import 'package:star_drive/features/auth/domain/usecase/send_otp_usecase.dart';
import 'package:star_drive/features/auth/domain/usecase/verified_otp_usecase.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:star_drive/features/map/data/repository/map_repository_imp.dart';
import 'package:star_drive/features/map/map_import.dart';
import '../network/dio_client.dart';
import 'package:star_drive/features/map/data/datasource/location_data_source.dart';
import 'package:star_drive/features/driver_verification/data/datasource/driver_documents_remote_datasource.dart';
import 'package:star_drive/features/driver_verification/data/datasource/vechile_detail_remote_datasource.dart';
import 'package:star_drive/features/driver_verification/data/repositories/driver_documents_repostories_impl.dart';
import 'package:star_drive/features/driver_verification/data/repositories/vechile_detail_repositories_imp.dart';
import 'package:star_drive/features/driver_verification/domain/repositories/driver_documents_repositories.dart';
import 'package:star_drive/features/driver_verification/domain/repositories/vechile_detail_repositories.dart';
import 'package:star_drive/features/driver_verification/domain/usecase/send_document_usecase.dart';
import 'package:star_drive/features/driver_verification/domain/usecase/vechile_detail_usecase.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/driver_verification_bloc/driver_verification_bloc.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/vechile_details_bloc/vechile_details_bloc_bloc.dart';

import '../storage/token_storage.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Map data source
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSource());

  // Map repository
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImp(sl<LocationDataSource>()),
  );

  // Map use case
  sl.registerLazySingleton<MapUseCase>(() => MapUseCase(sl<MapRepository>()));

  // Map BLoC
  sl.registerFactory<MapBloc>(() => MapBloc(sl<MapUseCase>()));
  // Shared HTTP client
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Shared HTTP client
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(tokenStorage: sl<TokenStorage>()),
  );

  // Repository implementation
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(
    sl<Dio>(),
    sl<DioClient>(),
    sl<TokenStorage>(),
  ),
);

  // Use case
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );

  // A new BLoC instance for each provider
  sl.registerLazySingleton<SendOtpUsecase>(() => SendOtpUsecase(sl()));

  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(registerUser: sl(), sendOtp: sl(), verifyOtpUseCase: sl()),
  );
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<LoginUseCase>()));
  sl.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(resetPasswordUseCase: sl<ResetPasswordUseCase>()),
  );

  sl.registerLazySingleton<DriverDocumentsRemoteDataSource>(
    () => DriverDocumentsRemoteDataSourceImpl(sl<DioClient>()),
  );

  sl.registerLazySingleton<DriverDocumentsRepository>(
    () => DriverDocumentsRepositoryImpl(sl<DriverDocumentsRemoteDataSource>()),
  );

  sl.registerLazySingleton(
    () => SendDocumentUseCase(sl<DriverDocumentsRepository>()),
  );
  sl.registerFactory(
    () => DriverVerificationBloc(sendDocument: sl<SendDocumentUseCase>()),
  );
  // Remote datasource
  sl.registerLazySingleton<VehicleDetailsRemoteDataSource>(
    () => VehicleDetailsRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<VehicleDetailsRepository>(
    () => VehicleDetailsRepositoryImpl(
      remoteDataSource: sl<VehicleDetailsRemoteDataSource>(),
    ),
  );

  // Use case
  sl.registerLazySingleton<SubmitVehicleDetailsUseCase>(
    () => SubmitVehicleDetailsUseCase(sl<VehicleDetailsRepository>()),
  );

  // BLoC
  sl.registerFactory<VehicleDetailsBloc>(
    () => VehicleDetailsBloc(sl<SubmitVehicleDetailsUseCase>()),
  );
}
