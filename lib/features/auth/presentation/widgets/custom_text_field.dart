import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/auth/presentation/widgets/auth_field_lable.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.passwordIconVisibility = false,
    this.obscureText = false,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.textInputFormatter,
    required this.labelText, 
    required this.icon,
  });

  final TextEditingController controller;

  final String hintText;
  final String labelText;
  final TextInputType?  keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool passwordIconVisibility;
  final String? Function(String?)? validator;
  final IconData icon;
  final List<TextInputFormatter>? textInputFormatter;
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: BorderSide(color: color),
  );


 static final List<TextInputFormatter> defaultInputFormatter = [
    FilteringTextInputFormatter.allow(
      RegExp(r"[a-zA-Z\u0600-\u06FF\s'-]"),
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthFieldLabel(text: labelText),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction:textInputAction,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),

            validator:
                validator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$hintText is required';
                  }
                  return null;
                },
                inputFormatters: textInputFormatter,
            decoration: InputDecoration(
              // labelText: labelText,
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              prefixIcon:  Icon(
                icon,
                // Icons.lock_outline_rounded,
                color: AppColors.textHint,
              ),

              suffixIcon: passwordIconVisibility
                  ? Icon(Icons.visibility)
                  : null,

              border: _border(AppColors.border),
              enabledBorder: _border(AppColors.border),
              focusedBorder: _border(AppColors.primary),
              errorBorder: _border(Colors.red),
              focusedErrorBorder: _border(Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
