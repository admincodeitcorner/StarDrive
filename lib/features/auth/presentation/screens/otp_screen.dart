import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/data/model/registration_data.dart';
import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_state.dart';
import 'package:star_drive/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:star_drive/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/driver_verification_screen.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  RegistrationData? registrationData;
  final OtpPurpose otpPurpose;
  final String contactNumber;
  final String? devCode;

  OtpScreen({
    super.key,
    this.devCode,
    this.registrationData,
    required this.contactNumber,
    required this.otpPurpose,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  bool _isSubmitting = false;

  void _verifyOtp() {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) return;

    final enteredOtp = _otpController.text.trim();

    // Forgot Password: server verification API call
    if (widget.otpPurpose == OtpPurpose.forgotPassword) {
      setState(() {
        _isSubmitting = true;
      });

      context.read<AuthBloc>().add(
        VerifyOtpRequested(
          contactNumber: widget.contactNumber,
          purpose: OtpPurpose.forgotPassword,
          code: enteredOtp,
        ),
      );

      return;
    }

    // Registration: existing OTP check
    final devCode = widget.devCode;
    final data = widget.registrationData;

    if (devCode == null || enteredOtp != devCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
      return;
    }

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration data is missing.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    context.read<AuthBloc>().add(
      RegisterRequested(
        name: data.name,
        fatherName: data.fatherName,
        cnic: data.cnic,
        contactNumber: data.contactNumber,
        address: data.address,
        role: data.role,
        dob: data.dob,
        password: data.password,
        otpCode: enteredOtp,
        fcmToken: data.fcmToken,
        androidId: data.androidId,
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              setState(() {
                _isSubmitting = true;
              });
            }
            if (state is OtpVerified) {
              final otpCode = widget.devCode;
              if (otpCode != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<ResetPasswordBloc>(
                      create: (_) => sl<ResetPasswordBloc>(),
                      child: ResetPasswordScreen(
                        contactNumber: widget.contactNumber,
                        otpCode: _otpController.text,
                      ),
                    ),
                  ),
                  (route) => false,
                );
              }
            }
            if (state is AuthSuccess) {
              setState(() {
                _isSubmitting = false;
              });

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => DriverVerificationScreen()),
                (route) => false,
              );
            }

            if (state is AuthFailure) {
              setState(() {
                _isSubmitting = false;
              });

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Enter the verification code sent to '
                      '${widget.contactNumber}.',
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: _otpController,
                      hintText: 'Enter OTP',
                      labelText: 'OTP',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter OTP';
                        }

                        if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
                          return 'Enter a valid 6-digit OTP';
                        }

                        return null;
                      },
                      icon: Icons.numbers,
                    ),

                    const SizedBox(height: 20),

                    AuthButton(
                      text: widget.otpPurpose == OtpPurpose.forgotPassword
                          ? 'Verify OTP'
                          : 'Verify & Register',
                      isLoading: _isSubmitting,
                      onPressed: _verifyOtp,
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
