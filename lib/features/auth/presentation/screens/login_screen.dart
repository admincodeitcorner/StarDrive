import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_state.dart';
import 'package:star_drive/features/auth/presentation/screens/forgot_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/signup.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:star_drive/features/map/presentation/screen/map_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _contactNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final contactNumber = _contactNumberController.text.trim();
    final password = _passwordController.text;

    if (contactNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact number aur password enter karein.'),
        ),
      );
      return;
    }

    context.read<LoginBloc>().add(
      LoginSubmitted(
        contactNumber: contactNumber,
        password: password,

        // Temporary test values.
        // Production mein actual FCM token aur Android ID dein.
        fcmToken: 'test-Fcm_token',
        androidId: 'testadnriod',
      ),
    );
  }

  @override
  void dispose() {
    _contactNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Welcome ${state.user.name}!')),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => MapScreen()),
                (route) => false,
              );
            }

            if (state is LoginFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login to StarDrive',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    CustomPhoneField(
                      controller: _contactNumberController,
                      labelText: 'Contact Number',
                      hintText: 'Enter contact number',
                      initialCountryCode: 'PK',
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      passwordIconVisibility:true,
                      labelText: 'Password',
                      controller: _passwordController,
                      hintText: 'Enter password',
                    ),

                    const SizedBox(height: 15),
                    Align(
                      alignment: .centerEnd,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ForgotScreen()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
                    ),
                    Row(
                      mainAxisAlignment: .end,
                      crossAxisAlignment: .center,
                      children: [
                        Text("Don't have Account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Signup()),
                            );
                          },
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
