import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({super.key, required this.onPressed});
final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const CircleBorder(),
      child: InkWell(
        onTap:onPressed,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Icon(
            Icons.my_location,
            size: 24,
          ),
        ),
      ),
    );
  }
}