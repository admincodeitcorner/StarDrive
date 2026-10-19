import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/app_bloc_observer.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:star_drive/features/auth/presentation/screens/login_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/signup.dart';
import 'package:star_drive/features/map/presentation/screen/map_screen.dart';

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
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (_) => sl<ResetPasswordBloc>(),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => sl<LoginBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: RoleSelectionScreen(),
      ),
    );
  }
}
