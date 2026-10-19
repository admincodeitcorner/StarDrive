import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';

import 'package:star_drive/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/login/login_state.dart';

import 'package:star_drive/features/auth/presentation/screens/forgot_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/signup.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_screen_header.dart';

import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_divider.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';
import 'package:star_drive/features/dashboard/presentation/screens/home.screen.dart';

import '../../../map/presentation/screen/map_screen.dart';
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

  void _onLoginState(BuildContext context, LoginState state) {
    final messenger = ScaffoldMessenger.of(context);

    if (state is LoginSuccess) {
      messenger.showSnackBar(
        SnackBar(content: Text('Welcome ${state.user.name}!')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }

    if (state is LoginFailure) {
      messenger.showSnackBar(SnackBar(content: Text(state.message)));
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
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: _onLoginState,
          builder: (context, state) {
            final isLoading = state is LoginLoading;

            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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

                          Row(
                            children: [
                              Expanded(
                                child: SocialButton(
                                  text: 'Apple ID',
                                  icon: const Icon(Icons.apple, size: 24),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SocialButton(
                                  text: 'Google',
                                  icon: Image.asset(
                                    'assets/icons/google.png',
                                    height: 22,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.g_mobiledata,
                                      size: 28,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),
                          const SizedBox(height: 24),

                          AuthRedirectText(
                            message: "Don't have an account?",
                            actionText: 'Register',
                            onTap: () => _push(Signup()),
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
    );
  }
}
