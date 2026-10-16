import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/api_colors.dart';

class AuthScreenHeader extends StatelessWidget {
  final String badge;
  final String titlePrefix;
  final String titleHighlight;
  final String subtitle;

  const AuthScreenHeader({
    super.key,
    this.badge = 'Ride Premium',
    required this.titlePrefix,
    required this.titleHighlight,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          height: 76,
          width: 76,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.primary, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          //  App Logo
          child: const Icon(
            Icons.album_outlined,
            color: AppColors.primary,
            size: 38,
          ),
        ),
        const SizedBox(height: 16),

        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text.rich(
          TextSpan(
            text: titlePrefix,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: titleHighlight,
                style: const TextStyle(color: AppColors.primary),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Subtitle
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
