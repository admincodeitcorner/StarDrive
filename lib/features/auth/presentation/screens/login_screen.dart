import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';

import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_state.dart';

import 'package:star_drive/features/auth/presentation/screens/forgot_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/passanger_signup_screen.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_header.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_screen_header.dart';

import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_divider.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';
import 'package:star_drive/features/dashboard/presentation/screens/home.screen.dart';

import '../../../driver/presentation/screen/driver_screen.dart';
import '../widgets/password_text_field.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _contactNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _completePhoneNumber = '';
  void _login() {
    if (!_formKey.currentState!.validate()) return;
    final phoneNumber = _completePhoneNumber.trim();
    context.read<LoginBloc>().add(
      LoginSubmitted(
        contactNumber: phoneNumber,
        password: _passwordController.text,
        fcmToken: 'test-Fcm_token',
        androidId: 'testadnriod',
      ),
    );
  }

Future<void> _onLoginState(
  BuildContext context,
  LoginState state,
) async {
  if (state is LoginSuccess) {
    final user = state.user;
    final role = user.role.toLowerCase();

    debugPrint('LOGIN ROLE: ${user.role}');
    debugPrint('LOGIN APPROVED: ${user.isApproved}');

    if (role == 'driver' && user.isApproved == false) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: const Icon(
              Icons.hourglass_top_rounded,
              color: Colors.orange,
              size: 48,
            ),
            title: const Text(
              'Driver Approval Pending',
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Your driver account is pending for admin approval. '
              'Please wait until your documents and vehicle details '
              'are verified.',
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          );
        },
      );

      
      return;
    }

    if (role == 'driver' && user.isApproved == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome ${user.name}!')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => DriverScreen(),
        ),
        (route) => false,
      );

      return;
    }

    if (role == 'passenger') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome ${user.name}!')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
        (route) => false,
      );

      return;
    }
  }

  if (state is LoginFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message)),
    );
  }
}
  void _push(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
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
      backgroundColor: AppColors.background,
      body: AuthBackground(
        child: SafeArea(
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: _onLoginState,
            builder: (context, state) {
              final isLoading = state is LoginLoading;

              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24),
                            const AuthScreenHeader(
                              titlePrefix: 'Login to Star',
                              titleHighlight: 'Drive',
                              subtitle:
                                  'Welcome back! Enter your credentials to\nmanage your trips and bookings.',
                            ),
                            const SizedBox(height: 32),
                            CustomPhoneField(
                              controller: _contactNumberController,
                              labelText: 'Contact Number',
                              hintText: '300 1234567',
                              initialCountryCode: 'PK',
                              onPhoneNumberChanged: (phoneNumber) {
                                _completePhoneNumber = phoneNumber;

                                debugPrint(
                                  'SAVED COMPLETE NUMBER: $_completePhoneNumber',
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            PasswordTextField(controller: _passwordController),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => _push(ForgotScreen()),
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            AuthButton(
                              text: 'Log In',
                              trailingIcon: Icons.arrow_forward_rounded,
                              isLoading: isLoading,
                              onPressed: _login,
                            ),
                            const SizedBox(height: 20),

                            const CustomDivider(),
                            const SizedBox(height: 20),
                            SocialSignInRow(),

                            const Spacer(),
                            const SizedBox(height: 24),

                            AuthRedirectText(
                              message: "Don't have an account?",
                              actionText: 'Register',
                              onTap: () => _push(PassengerSignUpScreen()),
                            ),
                            const SizedBox(height: 16),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
