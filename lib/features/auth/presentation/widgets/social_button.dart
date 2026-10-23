import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/core/constant/app_images.dart';

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
            image: Image.asset(AppImages.iphoneIcon),
            onPressed: onApple ?? () {}, // TODO: Apple sign in
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SocialButton(
            text: 'Google',
            image: Image.asset(AppImages.google),
            onPressed: onGoogle ?? () {}, // TODO: Google sign in
          ),
        ),
      ],
    );
  }
}
class SocialButton extends StatelessWidget {
  final String text;
  final Image image;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.image,
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
             SizedBox(
              width: 24,
              height: 24,
              child: FittedBox(
                fit: BoxFit.contain,
                child: image,
              ),
            ),
            
            const SizedBox(width: 10),
                       Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
