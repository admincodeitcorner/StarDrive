import 'dart:io';

import 'package:flutter/material.dart';
import 'document_slot.dart';

/// Reusable row widget that renders two document slots side by side.
class DocumentSlotRow extends StatelessWidget {
  const DocumentSlotRow({
    super.key,
    required this.frontLabel,
    required this.frontImage,
    required this.onPickFront,
    required this.onRemoveFront,
    required this.backLabel,
    required this.backImage,
    required this.onPickBack,
    required this.onRemoveBack,
    this.frontError,
    this.backError,
    this.enabled = true,
  });

  final String frontLabel;
  final File? frontImage;
  final VoidCallback onPickFront;
  final VoidCallback onRemoveFront;
  final String? frontError;

  final String backLabel;
  final File? backImage;
  final VoidCallback onPickBack;
  final VoidCallback onRemoveBack;
  final String? backError;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DocumentSlotCard(
            label: frontLabel,
            image: frontImage,
            onPick: onPickFront,
            onRemove: onRemoveFront,
            errorText: frontError,
            enabled: enabled,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: DocumentSlotCard(
            label: backLabel,
            image: backImage,
            onPick: onPickBack,
            onRemove: onRemoveBack,
            errorText: backError,
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}
