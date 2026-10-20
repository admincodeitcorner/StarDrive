import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/auth/data/model/registration_data.dart';
import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';
import 'package:star_drive/features/auth/domain/enums/user_role.dart';
import 'package:star_drive/features/auth/presentation/auth_validator.dart/auth_validator.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_event.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_state.dart';
import 'package:star_drive/features/auth/presentation/screens/login_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/otp_screen.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_header.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_screen_header.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_date_picker_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_divider.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/password_text_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/sign_up_top_bar.dart';
import 'package:star_drive/features/auth/presentation/widgets/social_button.dart';

class DriverSignUpScreen extends StatefulWidget {
  const DriverSignUpScreen({super.key});

  @override
  State<DriverSignUpScreen> createState() => _DriverSignUpScreenState();
}

class _DriverSignUpScreenState extends State<DriverSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  //Role
  final String _role = UserRole.driver.value;

  DateTime? _dob;
  String _completePhoneNumber = '';

  // replace with real value
  final String _fcmToken = 'test_fcm_token';
  final String _androidId = 'test_android_id';

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _cnicController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String get _dobApi => _dob == null
      ? ''
      : '${_dob!.year.toString().padLeft(4, '0')}-${_two(_dob!.month)}-${_two(_dob!.day)}';

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      SendOtpRequested(
        contactNumber: _completePhoneNumber.trim(),
        cnic: _cnicController.text.trim(),
        purpose: OtpPurpose.register,
      ),
    );
  }

  void _onAuthState(BuildContext context, AuthState state) {
    if (state is OtpSent) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            otpPurpose: OtpPurpose.register,
            contactNumber: _completePhoneNumber,
            devCode: state.devCode,
            registrationData: RegistrationData(
              name: _nameController.text.trim(),
              fatherName: _fatherNameController.text.trim(),
              cnic: _cnicController.text.trim(),
              contactNumber: _completePhoneNumber,
              address: _addressController.text.trim(),
              role: _role,
              dob: _dobApi,
              password: _passwordController.text,
              fcmToken: _fcmToken,
              androidId: _androidId,
            ),
          ),
        ),
        (route) => false,
      );
    }

    if (state is AuthFailure) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthBackground(
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: _onAuthState,
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SignupTOPBar(),
                      const AuthScreenHeader(
                        titlePrefix: 'Register With ',
                        titleHighlight: 'StarDrive',
                        subtitle:
                            'Create an account to earn as a verified partner driver.',
                      ),
                      CustomTextField(
                        labelText: 'Name',
                        controller: _nameController,
                        hintText: 'Enter name',
                        icon: Icons.person,
                        keyboardType: TextInputType.text,
                        textInputFormatter:
                            CustomTextField.defaultInputFormatter,
                        validator: AuthValidator.validateName,
                      ),
                      CustomTextField(
                        icon: Icons.person,
                        labelText: 'Father Name',
                        controller: _fatherNameController,
                        hintText: 'Enter father name',
                        validator: AuthValidator.validateName,
                        textInputFormatter:
                            CustomTextField.defaultInputFormatter,
                      ),
                      CustomPhoneField(
                        controller: _contactNumberController,
                        labelText: 'Contact Number',
                        hintText: '300 1234567',
                        initialCountryCode: 'PK',
                        onPhoneNumberChanged: (phoneNumber) {
                          _completePhoneNumber = phoneNumber;
                        },
                      ),
                      CustomTextField(
                        labelText: 'CNIC Number',
                        controller: _cnicController,
                        hintText: '42101-XXXXXXX-X',
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        validator: AuthValidator.validateCnic,
                      ),
                      CustomTextField(
                        labelText: 'Residential Address / City',
                        controller: _addressController,
                        hintText: 'e.g. DHA Phase 6, Karachi',
                        icon: Icons.home_outlined,
                        validator: AuthValidator.validateAddress,
                        textInputFormatter:
                            CustomTextField.defaultInputFormatter,
                      ),
                      CustomDatePickerField(
                        labelText: 'Date of Birth',
                        initialDate: _dob,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        onDateSelected: (selectedDate) => _dob = selectedDate,
                      ),
                      PasswordTextField(
                        controller: _passwordController,
                        validator: AuthValidator.validatePassword,
                      ),
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
                      const SizedBox(height: 20),
                      AuthButton(
                        text: 'Register Account',
                        trailingIcon: Icons.arrow_forward_rounded,
                        isLoading: isLoading,
                        onPressed: _register,
                      ),
                      const SizedBox(height: 16),
                      const CustomDivider(),
                      const SizedBox(height: 16),
                      const SocialSignInRow(),
                      const SizedBox(height: 24),
                      AuthRedirectText(
                        message: 'Already have an account?',
                        actionText: 'Log In',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
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
