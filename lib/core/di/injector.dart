import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:star_drive/features/dashboard/data/datasource/user_profile_remote_datasource.dart';
import 'package:star_drive/features/dashboard/data/repository/user_profile_repository_impl.dart';
import 'package:star_drive/features/dashboard/domain/repository/user_profile_repositories.dart';
import 'package:star_drive/features/dashboard/domain/usecase/get_user_profile.dart';
import 'package:star_drive/features/dashboard/domain/usecase/update_phone_number.dart';
import 'package:star_drive/features/dashboard/domain/usecase/verify_change_phone_otp_usecase.dart';
import 'package:star_drive/features/dashboard/presentation/bloc/user_profile_bloc.dart';
import 'package:star_drive/features/dashboard/data/datasource/ride_history_remote_datasource.dart';
import 'package:star_drive/features/dashboard/data/repository/ride_history_repository_impl.dart';
import 'package:star_drive/features/dashboard/domain/repository/ride_history_repository.dart';
import 'package:star_drive/features/dashboard/domain/usecase/get_ride_history.dart';
import 'package:star_drive/features/dashboard/presentation/screens/ride_history/presentation/bloc/ride_history_bloc.dart';
import 'package:star_drive/features/theme/data/datasource/theme_local_datasource.dart';
import 'package:star_drive/features/theme/data/repositories/theme_repository_impl.dart';
import 'package:star_drive/features/theme/domain/repositories/theme_repository.dart';
import 'package:star_drive/features/theme/domain/usecases/get_theme_mode.dart';
import 'package:star_drive/features/theme/domain/usecases/save_theme_mode.dart';
import 'package:star_drive/features/theme/presentation/bloc/theme_bloc.dart';
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
import 'package:star_drive/features/map/data/repository/map_repository_impl.dart';
import 'package:star_drive/features/map/map_import.dart';
import '../../features/become_driver/data/data_source/become_driver_remote_dataSource.dart';
import '../../features/become_driver/data/data_source/on_board_status_remote_datasource.dart';
import '../../features/become_driver/data/repositories/become_driver_repository_impl.dart';
import '../../features/become_driver/data/repositories/onboard_status_repository_impl.dart';
import '../../features/become_driver/domain/repositories/become_driver_repository.dart';
import '../../features/become_driver/domain/repositories/onboard_status_repository.dart';
import '../../features/become_driver/domain/usecase/become_driver_usecase.dart';
import '../../features/become_driver/presentation/bloc/becomeDriverBloc/become_driver_bloc.dart';
import '../../features/become_driver/presentation/bloc/onboard_status_bloc/onboard_status_bloc_bloc.dart';
import '../../features/map/data/repository/ride_estimate_repository_impl.dart';
import '../../features/map/domain/repository/ride_estimate_repository.dart' show RideEstimateRepository;
import '../../features/map/domain/usecase/ride_estimate_usecase.dart';
import '../../features/map/presentation/bloc/map_bloc/map_bloc.dart';
import '../../features/map/presentation/bloc/ride_estimate/ride_estimate_bloc.dart';
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
  // Shared HTTP client
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Shared HTTP client
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  // sl.registerLazySingleton<FlutterSecureStorage>(
  //   () => const FlutterSecureStorage(),
  // );

  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<DioClient>(
    () => DioClient(tokenStorage: sl<TokenStorage>()),
  );
// Auth Remote Data Source
sl.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(
    sl<Dio>(),
    sl<DioClient>(),
    sl<TokenStorage>(),
  ),
);
sl.registerLazySingleton(() => AuthLocalStorage());

   // Repository implementation
  sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    sl<AuthRemoteDataSource>(),
    sl<TokenStorage>(),
  ),
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
//   sl.registerLazySingleton<VerifyChangePhoneOtpUseCase>(
//   () => VerifyChangePhoneOtpUseCase(
//     sl<AuthRepository>(),
//   ),
// );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(registerUser: sl(), sendOtp: sl(), verifyOtpUseCase: sl(), authLocalStorage: sl()),
  );
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<LoginUseCase>(), sl<AuthLocalStorage>()));
  sl.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(resetPasswordUseCase: sl<ResetPasswordUseCase>()),
  );
//logout bloc
sl.registerLazySingleton<LogoutUseCase>(
  () => LogoutUseCase(sl<AuthRepository>()),
);

sl.registerFactory<LogoutBloc>(
  () => LogoutBloc(sl<LogoutUseCase>()),
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


  //Map Injection 
  sl.registerLazySingleton<LocationDataSource>(
  () => LocationDataSourceImpl(),
);

sl.registerLazySingleton<LocationRepository>(
  () => LocationRepositoryImpl(sl<LocationDataSource>()),
);

sl.registerFactory<MapBloc>(
  () => MapBloc(sl<LocationRepository>()),
);
// sl.registerLazySingleton<RouteDataSource>(
//   () => RouteDataSourceImpl(
//     sl<DioClient>(),
//   ));
  //Become Driver
  sl.registerLazySingleton<BecomeDriverRemoteDataSource>(
  () => BecomeDriverRemoteDataSourceImpl(
    sl<DioClient>(),
  ),
);

sl.registerLazySingleton<BecomeDriverRepository>(
  () => BecomeDriverRepositoryImpl(
    remoteDataSource: sl<BecomeDriverRemoteDataSource>(),
    tokenStorage: sl<TokenStorage>(),
  ),
);

sl.registerLazySingleton<BecomeDriverUseCase>(
  () => BecomeDriverUseCase(
    sl<BecomeDriverRepository>(),
  ),
);

sl.registerFactory<BecomeDriverBloc>(
  () => BecomeDriverBloc(
    sl<BecomeDriverUseCase>(),
  ),
);
//onboard Status
// Data source
sl.registerLazySingleton<OnboardingRemoteDataSource>(
  () => OnboardingRemoteDataSourceImpl(
    dioClient: sl<DioClient>(),
  // History DataSource
sl.registerLazySingleton<HistoryRemoteDataSource>(
  () => HistoryRemoteDataSourceImpl(
    sl<Dio>(),
  ),
);

// History Repository
sl.registerLazySingleton<HistoryRepository>(
  () => HistoryRepositoryImpl(
    sl<HistoryRemoteDataSource>(),
  ),
);

// History UseCase
sl.registerLazySingleton<GetRideHistory>(
  () => GetRideHistory(
    sl<HistoryRepository>(),
  ),
);

// History BLoC
sl.registerFactory<HistoryBloc>(
  () => HistoryBloc(
    getRideHistory: sl<GetRideHistory>(),
  ),
);

// Data Source
sl.registerLazySingleton<UserProfileRemoteDataSource>(
  () => UserProfileRemoteDataSourceImpl(
    dio: sl<Dio>(),
  ),
);

// Repository
sl.registerLazySingleton<OnboardingRepository>(
  () => OnboardingRepositoryImpl(
    remoteDataSource: sl<OnboardingRemoteDataSource>(),
  ),
);

// Use case
sl.registerLazySingleton(
  () => OnboardingStatusUseCase(sl<OnboardingRepository>()),
);

// BLoC
sl.registerFactory(
  () => OnboardingBloc(
    getOnboardingStatus: sl<OnboardingStatusUseCase>(),
  ),
);
//rideEstimate
// Data source
sl.registerLazySingleton<RideEstimateRemoteDataSource>(
  () => RideEstimateRemoteDataSourceImpl(
    dioClient: sl(),
  ),
);

// Repository
sl.registerLazySingleton<RideEstimateRepository>(
  () => RideEstimateRepositoryImpl(
    remoteDataSource: sl(),
    
  ),
);

// Use case
sl.registerLazySingleton(
  () => GetRideEstimate(sl()),
);

// BLoC
sl.registerFactory(
  () => RideEstimateBloc(
    getRideEstimate: sl(),
sl.registerLazySingleton<UserProfileRepository>(
  () => UserProfileRepositoryImpl(
    sl<UserProfileRemoteDataSource>(),
  ),
);

// UseCase
sl.registerLazySingleton<GetUserProfile>(
  () => GetUserProfile(
    repository: sl<UserProfileRepository>(),
  ),
);

//updatePhoneNumber
sl.registerLazySingleton<UpdatePhoneNumber>(
  () => UpdatePhoneNumber(
    repository: sl<UserProfileRepository>(),
  ),
);

// Theme local data source
sl.registerLazySingleton<ThemeLocalDataSource>(
  () => ThemeLocalDataSource(
    Hive.box<String>('theme_settings'),
  ),
);

// Theme repository
sl.registerLazySingleton<ThemeRepository>(
  () => ThemeRepositoryImpl(
    sl<ThemeLocalDataSource>(),
  ),
);

// Get saved theme
sl.registerLazySingleton<GetThemeMode>(
  () => GetThemeMode(
    sl<ThemeRepository>(),
  ),
);

// Save selected theme
sl.registerLazySingleton<SaveThemeMode>(
  () => SaveThemeMode(
    sl<ThemeRepository>(),
  ),
);

// Theme BLoC
sl.registerFactory<ThemeBloc>(
  () => ThemeBloc(
    getThemeMode: sl<GetThemeMode>(),
    saveThemeMode: sl<SaveThemeMode>(),
  ),
);

// BLoC
sl.registerFactory<UserProfileBloc>(
  () => UserProfileBloc(
    getUserProfile: sl<GetUserProfile>(),
    updatePhoneNumber: sl<UpdatePhoneNumber>(),
    sendOtpUsecase: sl<SendOtpUsecase>(),
    // verifyChangePhoneOtpUseCase:
    //     sl<VerifyChangePhoneOtpUseCase>(),
  ),
);
}
