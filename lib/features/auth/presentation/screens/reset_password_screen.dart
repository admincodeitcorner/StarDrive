import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:star_drive/features/auth/presentation/auth_validator.dart/auth_validator.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_state.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/password_text_field.dart';
import 'package:star_drive/features/dashboard/presentation/screens/home.screen.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String contactNumber;
  final String otpCode;

  const ResetPasswordScreen({
    super.key,
    required this.contactNumber,
    required this.otpCode,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void resetPassword() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ResetPasswordBloc>().add(
      ResetPasswordSubmitted(
        contactNumber: widget.contactNumber,
        otpCode: widget.otpCode,
        newPassword: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              );
            }

            if (state is ResetPasswordFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is ResetPasswordLoading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.lock_reset,
                        size: 64,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Create New Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        'Enter your new password to secure your account.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      PasswordTextField(
                        controller: _passwordController,
                        validator: AuthValidator.validatePassword,
                      ),
                      const SizedBox(height: 16),

                      PasswordTextField(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter password',
                        controller: _confirmPasswordController,
                        validator: (value) =>
                            AuthValidator.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                      ),
                      const SizedBox(height: 24),

                      AuthButton(
                        text: 'Reset Password',
                        isLoading: isLoading,
                        onPressed: resetPassword,
                      ),
                    ],
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
