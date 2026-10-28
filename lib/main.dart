import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:star_drive/app_bloc_observer.dart';
import 'package:star_drive/core/constant/theme/app_theme.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:star_drive/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:star_drive/features/become_driver/presentation/bloc/becomeDriverBloc/become_driver_bloc.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/driver_verification_bloc/driver_verification_bloc.dart';
import 'features/driver_verification/presentataion/bloc/vechile_details_bloc/vechile_details_bloc_bloc.dart';
import 'package:star_drive/features/map/presentation/screen/map_screen.dart';

import 'features/auth/data/dataresource/local/auth_local_data_storage.dart';
import 'features/map/map_import.dart';
import 'features/map/presentation/bloc/ride_estimate/ride_estimate_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Hive initialize karo
  // final directory = await getApplicationDocumentsDirectory();
  // Hive.init(directory.path);

  // // User data save karne ke liye box open karo
  // await Hive.openBox('userBox');
  await Hive.openBox<String>('theme_settings');

  Bloc.observer = AppBlocObserver();
  setupDependencies();
  await Hive.initFlutter();
  await AuthLocalStorage.init();
  final user = AuthLocalStorage.init();
  debugPrint(user.toString());

  runApp(const StarDriveApp());
}

class StarDriveApp extends StatelessWidget {
  const StarDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<ResetPasswordBloc>(create: (_) => sl<ResetPasswordBloc>()),
        BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
        BlocProvider<DriverVerificationBloc>(
          create: (_) => sl<DriverVerificationBloc>(),
        ),
        BlocProvider<VehicleDetailsBloc>(
          create: (_) => sl<VehicleDetailsBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<MapBloc>()..add(const InitializeMapEvent()),
        ),
        BlocProvider(create: (_) => sl<BecomeDriverBloc>()),
        BlocProvider(create: (_) => sl<RideEstimateBloc>()),
                BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),

      ],
      
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return ScreenUtilPlusInit(
            designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        autoRebuild: false,
            builder: (context, child) {
              return MaterialApp(
                 debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.mode,
              home: SplashScreen(),
              );
            },
            child: MaterialApp(
             
            ),
          );
        },
      ),
    );
  }
}
