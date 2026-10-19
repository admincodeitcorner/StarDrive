import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_field_lable.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String initialCountryCode;
  final int maxDigits;

    final ValueChanged<String>? onPhoneNumberChanged;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.labelText = 'Contact Number',
    this.hintText = '300 1234567',
    this.initialCountryCode = 'PK',
    this.maxDigits = 10,
    this.onPhoneNumberChanged,
  });

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(
          text: labelText,
          trailing: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) => Text(
              '${value.text.length}/$maxDigits',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textHint,
              ),
            ),
          ),
        ),
        IntlPhoneField(
          controller: controller,
          initialCountryCode: initialCountryCode,
          keyboardType: TextInputType.phone,
          disableLengthCheck: false,
          dropdownIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textHint,
          ),
          dropdownTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          flagsButtonPadding: const EdgeInsets.only(left: 12),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.textHint),
            counterText: '',
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary),
            errorBorder: _border(Colors.red),
            focusedErrorBorder: _border(Colors.red),
          ),

          // Country code + phone number
          onChanged: (phone) {
            onPhoneNumberChanged?.call(phone.completeNumber);

            debugPrint('Country code: ${phone.countryCode}');
            debugPrint('National number: ${phone.number}');
            debugPrint('Complete number: ${phone.completeNumber}');
          },
        ),
      ],
    );
  }
}