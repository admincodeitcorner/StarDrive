import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/auth/data/model/registration_data.dart';
import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';
import 'package:star_drive/features/auth/domain/enums/user_role.dart';
import 'package:star_drive/features/auth/presentation/auth_validator.dart/auth_validator.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';

import 'package:star_drive/features/auth/presentation/screens/login_screen.dart';
import 'package:star_drive/features/auth/presentation/screens/otp_screen.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_field_lable.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_header.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_redirect_text.dart';

import 'package:star_drive/features/auth/presentation/widgets/auth_role_selector.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_screen_header.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_divider.dart';

import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/password_text_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/sign_up_top_bar.dart';
import 'package:star_drive/features/auth/presentation/widgets/social_button.dart';
import 'package:star_drive/core/constant/api_colors.dart';

import '../bloc/register/register_event.dart';
import '../bloc/register/register_state.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final cnicController = TextEditingController();
  final contactNumberController = TextEditingController();
  final addressController = TextEditingController();
  final dateOfBirthController =
      TextEditingController(); // display: dd / MM / yyyy
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
      bool get _isDriver => role == UserRole.driver.value;

  String role = 'Passenger';
  DateTime? _dob;

  final String fcmToken = 'test_fcm_token';
  final String androidId = 'test_android_id';
  String _completePhoneNumber = '';
  @override
  void dispose() {
    nameController.dispose();
    fatherNameController.dispose();
    cnicController.dispose();
    contactNumberController.dispose();
    addressController.dispose();
    dateOfBirthController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String get _dobApi => _dob == null
      ? ''
      : '${_dob!.year.toString().padLeft(4, '0')}-${_two(_dob!.month)}-${_two(_dob!.day)}';

  void _onDateSelected(DateTime selectedDate) {
    _dob = selectedDate;

    dateOfBirthController.text =
        '${selectedDate.day.toString().padLeft(2, '0')} / '
        '${selectedDate.month.toString().padLeft(2, '0')} / '
        '${selectedDate.year.toString().padLeft(4, '0')}';
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    final phoneNumber = _completePhoneNumber.trim();

    context.read<AuthBloc>().add(
      SendOtpRequested(
        contactNumber: phoneNumber,
        cnic: cnicController.text.trim(),
        purpose: OtpPurpose.register,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AuthBackground(
        child: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is OtpSent) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => OtpScreen(
                      otpPurpose: OtpPurpose.register,
                      contactNumber: _completePhoneNumber,
                      devCode: state.devCode,
                      registrationData: RegistrationData(
                        name: nameController.text.trim(),
                        fatherName: fatherNameController.text.trim(),
                        cnic: cnicController.text.trim(),
                        contactNumber: _completePhoneNumber,
                        address: addressController.text.trim(),
                        role: role,
                        dob: _dobApi,
                        password: passwordController.text,
                        fcmToken: fcmToken,
                        androidId: androidId,
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
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SignupTOPBar(),
                      const AuthScreenHeader(
                        titlePrefix: 'Register With ',
                        titleHighlight: 'StarDrive',
                        subtitle:
                            'Create an account to book premium rides or earn as a verified partner driver.',
                      ),
                      AuthRoleSelector(
                        value: role,
                        onChanged: (v) => setState(() => role = v),
                      ),
                      CustomTextField(
                        labelText: 'Name',
                        controller: nameController,
                        hintText: 'Enter name',
                        icon: Icons.person,
                        keyboardType: .text,
                        textInputFormatter:
                            CustomTextField.defaultInputFormatter,
                        validator: AuthValidator.validateName,
                      ),
                      CustomTextField(
                        icon: Icons.person,
                        labelText: 'Father Name',
                        controller: fatherNameController,
                        hintText: 'Enter father name',
                        validator: AuthValidator.validateName,
                        textInputFormatter:
                            CustomTextField.defaultInputFormatter,
                      ),
                      CustomPhoneField(
                        controller: contactNumberController,
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
                      CustomTextField(
                        labelText: 'CNIC Number',
                        controller: cnicController,
                        hintText: '42101-XXXXXXX-X',
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        validator: AuthValidator.validateCnic,
                      ),
                      CustomTextField(
                        labelText: 'Residential Address / City',
                        controller: addressController,
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
                        onDateSelected: (selectedDate) {
                          _dob = selectedDate;
                        },
                      ),
                      // CustomTextField(
                      //   labelText: 'Date of Birth',
                      //   controller: dateOfBirthController,
                      //   hintText: 'DD / MM / YYYY',
                      //   readOnly: true,
                      //   onTap: _selectDate,
                      //   suffixIcon: const Icon(
                      //     Icons.calendar_month_outlined,
                      //     color: AppColors.textHint,
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please select date of birth';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      PasswordTextField(
                        controller: passwordController,
                        validator: AuthValidator.validatePassword,
                      ),
                      PasswordTextField(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter password',
                        controller: confirmPasswordController,
                        validator: (value) =>
                            AuthValidator.validateConfirmPassword(
                              value,
                              passwordController.text,
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
                      Row(
                        children: [
                          Expanded(
                            child: SocialButton(
                              text: 'Apple ID',
                              icon: const Icon(
                                Icons.apple,
                                size: 22,
                                color: AppColors.textPrimary,
                              ),
                              onPressed: () {}, // TODO: Apple sign in
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SocialButton(
                              text: 'Google',
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                              onPressed: () {}, // TODO: Google sign in
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AuthRedirectText(
                        message: 'Already have an account?',
                        actionText: 'Log In',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // const AuthTermsText(),
                      // const SizedBox(height: 24),
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


class CustomDatePickerField extends StatefulWidget {
  const CustomDatePickerField({
    super.key,
    required this.labelText,
    required this.onDateSelected,
    this.hintText = 'YYYY/MM/DD',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.errorText = 'Please select a date',
  });

  final String labelText;
  final String hintText;
  final String errorText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  late final TextEditingController _controller;
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate;
    _controller = TextEditingController(
      text: _selected == null ? '' : _format(_selected!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  String _format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')} / ${_two(d.month)} /${_two(d.day)}';

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selected ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null && mounted) {
      setState(() {
        _selected = picked;
        _controller.text = _format(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthFieldLabel(text: widget.labelText),
          TextFormField(
            controller: _controller,
            readOnly: true,
            onTap: _pickDate,
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
            validator: (value) =>
                (value == null || value.isEmpty) ? widget.errorText : null,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              suffixIcon: IconButton(
                onPressed: _pickDate,
                icon: const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
