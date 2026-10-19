import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/app_colors.dart';


class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFEEE0), AppColors.background],
          stops: [0, 0.55],
        ),
      ),
      child: child,
    );
  }
}