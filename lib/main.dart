import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:star_drive/app_bloc_observer.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:star_drive/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/driver_verification_bloc/driver_verification_bloc.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/vechile_details_bloc/vechile_details_bloc_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: ScreenUtilPlusInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        autoRebuild: false,
      builder: (context,child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: RoleSelectionScreen(),
      
        );
      }
      ),
    );
  }
}
