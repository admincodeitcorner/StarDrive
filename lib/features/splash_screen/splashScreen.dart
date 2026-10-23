import 'package:flutter/material.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/core/storage/token_storage.dart';
import 'package:star_drive/features/auth/data/dataresource/user_local_datasource.dart';
import 'package:star_drive/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:star_drive/features/dashboard/presentation/screens/home.screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final stopwatch = Stopwatch()..start();
    Widget destination = const RoleSelectionScreen();

    try {
      final user = sl<UserLocalDataSource>().getAuthUser();
      final token = await sl<TokenStorage>().getToken();

      final isLoggedIn =
          user != null && token != null && token.trim().isNotEmpty;

      if (isLoggedIn) {
        destination = const HomeScreen();
      }
    } catch (error, stackTrace) {
      debugPrint('Splash session check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    final remaining = const Duration(milliseconds: 1200) - stopwatch.elapsed;

    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'StarDrive App',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Icon(Icons.drive_eta, size: 50),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}



// App open hoti hai — main.dart pehle Hive initialize karke userBox kholta hai, phir app SplashScreen se start hoti hai.
// Splash session check karti hai — splashScreen.dart Hive se saved user aur secure storage se token check karti hai. Dono valid hon to HomeScreen, warna RoleSelectionScreen. 
// Role Selection par — role_selection_screen.dart mein Passenger ya Driver tap karne se us role ka signup screen khulta hai. 
// Login par — login_bloc.dart successful login ke baad user Hive mein save hota hai. Token secure storage mein save hota hai. Phir login_screen.dart HomeScreen kholti hai.

