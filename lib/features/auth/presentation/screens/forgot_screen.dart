import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_state.dart';
import 'package:star_drive/features/auth/presentation/screens/otp_screen.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _contactNumberController = TextEditingController();
  String _completePhoneNumber = '';
  void sendOtp() {
    debugPrint('1. Send OTP button clicked');

    final contactNumber = _completePhoneNumber.trim();

    if (contactNumber.isEmpty) {
      debugPrint('Phone number is empty');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    debugPrint('2. Dispatching SendOtpRequested');

    context.read<AuthBloc>().add(
      SendOtpRequested(
        contactNumber: contactNumber,
        cnic: '',
        purpose: OtpPurpose.forgotPassword,
      ),
    );

    debugPrint('3. Event added to AuthBloc');
  }

  @override
  void dispose() {
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is OtpSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('OTP sent successfully')),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OtpScreen(
                
                     otpPurpose: OtpPurpose.forgotPassword,
                     contactNumber:   _completePhoneNumber ,
                     devCode: state.devCode,
 
                  ),
                ),
              );
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your registered phone number to receive an OTP.',
                ),
                const SizedBox(height: 24),

                CustomPhoneField(
                  controller: _contactNumberController,
                  labelText: 'Contact Number',
                  hintText: '300 1234567',
                  initialCountryCode: 'PK',
                  onPhoneNumberChanged: (phoneNumber) {
                    setState(() {
                      _completePhoneNumber = phoneNumber;
                    });

                    debugPrint('SAVED COMPLETE NUMBER: $_completePhoneNumber');
                  },
                ),
                const SizedBox(height: 20),

                AuthButton(
                  text: 'Send OTP',
                  isLoading: isLoading,
                  onPressed: sendOtp,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
