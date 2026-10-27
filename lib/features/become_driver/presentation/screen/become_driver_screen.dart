import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_screen_header.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/driver_verification_screen.dart';
import '../../../auth/presentation/widgets/custom_auth_button.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_text_field.dart';
import '../../domain/entity/become_driver_request_entity.dart';

import '../../../auth/presentation/auth_validator.dart/auth_validator.dart';
import '../../../widgets/custom_date_picker.dart';
import '../becomeDriverBloc/become_driver_bloc.dart';
import '../becomeDriverBloc/become_driver_event.dart';
import '../becomeDriverBloc/become_driver_state.dart';

class BecomeDriverScreen extends StatefulWidget {
  const BecomeDriverScreen({super.key});

  @override
  State<BecomeDriverScreen> createState() => _BecomeDriverScreenState();
}

class _BecomeDriverScreenState extends State<BecomeDriverScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cnicController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();

  DateTime? _selectedDob;

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  Future<void> _selectDob() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 18, 1, 1),
      firstDate: DateTime(1940),
      lastDate: now,
      helpText: 'Select date of birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = _formatDate(picked);
      });
    }
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<BecomeDriverBloc>().add(
      SubmitBecomeDriver(
        BecomeDriverRequestEntity(
          cnic: _cnicController.text.trim(),
          fatherName: _fatherNameController.text.trim(),
          address: _addressController.text.trim(),
          dob: _formatDate(_selectedDob!),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, BecomeDriverState state) {
    final messenger = ScaffoldMessenger.of(context);
    if (state is BecomeDriverSuccess) {
      messenger.showSnackBar(SnackBar(content: Text(state.driver.message)));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DriverVerificationScreen()),
        (route) => false,
      );
    } else if (state is BecomeDriverFailure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  void dispose() {
    _cnicController.dispose();
    _fatherNameController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Become a Driver',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<BecomeDriverBloc, BecomeDriverState>(
          listener: _onStateChanged,
          builder: (context, state) {
            final loading = state is BecomeDriverLoading;
            debugPrint('BecomeDriver state: ${state.runtimeType}');
            debugPrint('BecomeDriver loading: $loading');
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // const SizedBox(height: 24),
                          // const AuthScreenHeader(
                          //   titlePrefix: 'Become a ',
                          //   titleHighlight: 'Driver',
                          //   subtitle:
                          //       'Enter your personal details to create your driver profile.',
                          // ),
                          const SizedBox(height: 28),

                          CustomTextField(
                            labelText: 'CNIC Number',
                            controller: _cnicController,
                            hintText: '42101-XXXXXXX-X',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                            validator: AuthValidator.validateCnic,
                          ),
                          const SizedBox(height: 18),

                          CustomTextField(
                            icon: Icons.person,
                            labelText: 'Father Name',
                            controller: _fatherNameController,
                            hintText: 'Enter father name',
                            validator: AuthValidator.validateName,
                            textInputFormatter:
                                CustomTextField.defaultInputFormatter,
                          ),
                          const SizedBox(height: 18),

                          CustomTextField(
                            labelText: 'Residential Address / City',
                            controller: _addressController,
                            hintText: 'e.g. DHA Phase 6, Karachi',
                            icon: Icons.home_outlined,
                            validator: AuthValidator.validateAddress,
                            textInputFormatter:
                                CustomTextField.defaultInputFormatter,
                          ),
                          const SizedBox(height: 18),

                          CustomDatePickerField(
                            labelText: 'Date of Birth',
                            initialDate: _selectedDob,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            onDateSelected: (selectedDate) =>
                                _selectedDob = selectedDate,
                          ),
                          const SizedBox(height: 28),

                          AuthButton(
                            text: 'Create Driver Profile',
                            trailingIcon: Icons.arrow_forward_rounded,
                            isLoading: loading,
                            onPressed: _submit,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
