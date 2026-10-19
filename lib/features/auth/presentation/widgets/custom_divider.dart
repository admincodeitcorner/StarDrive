import 'package:flutter/material.dart';

import 'package:star_drive/core/constant/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  const CustomDivider({super.key, this.text = 'Or continue with'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              letterSpacing: 1,
              color: AppColors.textHint,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

