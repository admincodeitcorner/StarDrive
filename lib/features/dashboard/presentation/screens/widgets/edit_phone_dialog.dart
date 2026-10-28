import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:star_drive/core/constant/app_colors.dart';

class EditPhoneDialog extends StatefulWidget {
  final String initialPhoneNumber;

  const EditPhoneDialog({super.key, required this.initialPhoneNumber});

  @override
  State<EditPhoneDialog> createState() => _EditPhoneDialogState();
}

class _EditPhoneDialogState extends State<EditPhoneDialog> {
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    var digits = widget.initialPhoneNumber.replaceAll(RegExp(r'\D'), '');

    // International number se country code remove karo.
    if (digits.startsWith('0092')) {
      digits = digits.substring(4);
    } else if (digits.startsWith('92') && digits.length > 10) {
      digits = digits.substring(2);
    }

    // 0348... ko 348... mein convert karo.
    if (digits.startsWith('0') && digits.length == 11) {
      digits = digits.substring(1);
    }

    if (digits.length > 10) {
      digits = digits.substring(digits.length - 10);
    }

    phoneController = TextEditingController(text: digits);

    // Existing digits select honge taake easily replace kar sako.
    phoneController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: phoneController.text.length,
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _saveNumber() {
    final number = phoneController.text.trim();

    if (number.length != 10 || !number.startsWith('3')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid 10-digit mobile number starting with 3.',
          ),
        ),
      );
      return;
    }

    // Complete phone number ProfileSettingScreen ko return karo.
    // Example: 3483098360 -> +923483098360
    Navigator.of(context).pop('+92$number');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,

      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 22),

      title: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Update your mobile number',
                  style: TextStyle(fontSize: 12, color: secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Mobile number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: phoneController,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: textColor,
            ),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.phone_iphone_rounded,
                color: AppColors.primary,
              ),
              prefixText: '+92 ',
              prefixStyle: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              hintText: '3481234567',
              counterText: '',
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFFFF8F0),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.8,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: secondaryTextColor,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Enter 10 digits after +92. OTP verification will be required.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.shadow,
                    foregroundColor: textColor,
                    side: const BorderSide(color: AppColors.shadow),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _saveNumber,
                  label: const Text(
                    'Save',
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
