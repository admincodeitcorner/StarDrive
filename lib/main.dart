import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:star_drive/app_bloc_observer.dart';
import 'package:star_drive/core/constant/theme/app_theme.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:star_drive/features/dashboard/presentation/screens/home.screen.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/driver_verification_bloc/driver_verification_bloc.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/vechile_details_bloc/vechile_details_bloc_bloc.dart';
import 'package:star_drive/features/splash_screen/splashScreen.dart';
import 'package:star_drive/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:star_drive/features/theme/presentation/bloc/theme_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialize karo
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // User data save karne ke liye box open karo
  await Hive.openBox('userBox');
  await Hive.openBox<String>('theme_settings');

  Bloc.observer = AppBlocObserver();
  setupDependencies();

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
        BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.mode,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
