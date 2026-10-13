import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:star_drive/features/auth/presentation/screens/login_screen.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_phone_field.dart';
import 'package:star_drive/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:star_drive/features/map/map_screen.dart';

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
  final dateOfBirthController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String role = 'Driver';

  // Inhein real Firebase/device values se replace karein.
  final String fcmToken = 'test_fcm_token';
  final String androidId = 'test_android_id';

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

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (selectedDate != null && mounted) {
      dateOfBirthController.text =
          '${selectedDate.year.toString().padLeft(4, '0')}-'
          '${selectedDate.month.toString().padLeft(2, '0')}-'
          '${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      RegisterRequested(
        name: nameController.text.trim(),
        fatherName: fatherNameController.text.trim(),
        cnic: cnicController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        address: addressController.text.trim(),
        role: role,
        dob: dateOfBirthController.text.trim(),
        password: passwordController.text,
        fcmToken: fcmToken,
        androidId: androidId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful!')),
              );

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => MapScreen()),
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
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: 'Name',
                      controller: nameController,
                      hintText: 'Enter name',
                    ),
                    CustomTextField(
                      labelText: 'Father Name',
                      controller: fatherNameController,
                      hintText: 'Enter father name',
                    ),
                    CustomTextField(
                      labelText: 'CNIC',
                      controller: cnicController,
                      hintText: 'Enter CNIC',
                    ),
                    CustomPhoneField(
                      controller: contactNumberController,
                      labelText: 'Contact Number',
                      hintText: 'Enter contact number',
                      initialCountryCode: 'PK',
                    ),
                    CustomTextField(
                      labelText: 'Address',
                      controller: addressController,
                      hintText: 'Enter address',
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        value: role,
                        decoration: const InputDecoration(
                          labelText: 'Register as',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Driver',
                            child: Text('Driver'),
                          ),
                          DropdownMenuItem(
                            value: 'Passenger',
                            child: Text('Passenger'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => role = value);
                          }
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: dateOfBirthController,
                        readOnly: true,
                        onTap: _selectDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select date of birth';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Select date of birth',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                      ),
                    ),

                    CustomTextField(
                      passwordIconVisibility:true,
                      labelText: 'Password',
                      controller: passwordController,
                      hintText: 'Enter password',
                      obscureText: true,
                    ),
                    CustomTextField(
                      labelText: 'Confrim Password',
                      controller: confirmPasswordController,
                      hintText: 'Confirm password',
                      passwordIconVisibility:true,
                      obscureText: true,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: isLoading ? null : _register,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Register'),
                    ),
                     Row(
                      mainAxisAlignment: .end,
                      crossAxisAlignment: .center,
                      children: [
                        Text("Already Account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text('Login Screen'),
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
