import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/app_colors.dart';

class SocialSignInRow extends StatelessWidget {
  const SocialSignInRow({super.key, this.onApple, this.onGoogle});

  final VoidCallback? onApple;
  final VoidCallback? onGoogle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            text: 'Apple ID',
            icon: const Icon(Icons.apple, size: 22, color: AppColors.textPrimary),
            onPressed: onApple ?? () {}, // TODO: Apple sign in
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
            onPressed: onGoogle ?? () {}, // TODO: Google sign in
          ),
        ),
      ],
    );
  }
}
class SocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
