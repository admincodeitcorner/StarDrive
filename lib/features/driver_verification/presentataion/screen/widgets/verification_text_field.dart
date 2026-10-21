import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_drive/core/constant/app_colors.dart';

/// Reusable input field for driver verification forms.
class VerificationTextField extends StatelessWidget {
  const VerificationTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  OutlineInputBorder _border([Color? color, double width = 1.0]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: color == null
            ? const BorderSide(color: AppColors.border, width: 1.0)
            : BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.textHint),
            errorText: errorText,
            filled: true,
            fillColor: enabled ? AppColors.fieldFill : Colors.grey.shade100,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: _border(),
            enabledBorder: _border(),
            disabledBorder: _border(Colors.grey.shade300),
            focusedBorder: _border(AppColors.primary, 1.5),
            errorBorder: _border(AppColors.error, 1.2),
            focusedErrorBorder: _border(AppColors.error, 1.5),
          ),
        ),
      ],
    );
  }
}