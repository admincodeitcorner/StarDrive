import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/api_colors.dart';

class SignupTOPBar extends StatelessWidget {
  // final String? stepText;

  const SignupTOPBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: AppColors.surface,
            shape: const CircleBorder(),
            elevation: 3,
            shadowColor: Colors.black12,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
