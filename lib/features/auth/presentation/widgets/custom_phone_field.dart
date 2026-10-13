import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String initialCountryCode;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.labelText = 'Phone Number',
    this.hintText = 'Enter contact number',
    this.initialCountryCode = 'PK',
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      initialCountryCode: initialCountryCode,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      onChanged: (phone) {
        debugPrint(phone.completeNumber);
      },
    );
  }
}