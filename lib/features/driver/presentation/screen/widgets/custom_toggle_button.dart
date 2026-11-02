import 'package:flutter/material.dart';

class CustomToggleButton extends StatelessWidget {
  const CustomToggleButton({
    super.key,
    required this.isOnline,
    required this.isBusy,
    required this.loadingIndex,
    required this.onPressed,
  });

  final bool isOnline;
  final bool isBusy;
  final int? loadingIndex;
  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      // Selection always mirrors the BLoC state.
      isSelected: [!isOnline, isOnline],
      borderRadius: BorderRadius.circular(12),
      selectedColor: Colors.white,
      color: Colors.black87,
      fillColor: Colors.orange,
      borderColor: Colors.grey,
      selectedBorderColor: Colors.orange,
      onPressed: isBusy ? null : onPressed,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: (isBusy && loadingIndex == 0)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: !isOnline ? Colors.white : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('Offline'),
                  ],
                )
              : const Text('Offline'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: (isBusy && loadingIndex == 1)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isOnline ? Colors.white : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('Online'),
                  ],
                )
              : const Text('Online'),
        ),
      ],
    );
  }
}
