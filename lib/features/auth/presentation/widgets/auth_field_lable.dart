import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/api_colors.dart';

class AuthFieldLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const AuthFieldLabel({super.key, required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.textLabel,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
