import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:star_drive/core/constant/app_colors.dart';

/// Opens a modal bottom sheet to pick an image from camera or gallery.
Future<File?> pickDocumentImage(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Photo Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.photo_camera_outlined, color: AppColors.primary),
              ),
              title: const Text('Take a photo', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Capture using device camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.photo_library_outlined, color: AppColors.primary),
              ),
              title: const Text('Choose from gallery', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Select an image from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ),
  );

  if (source == null) return null;

  try {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    return picked == null ? null : File(picked.path);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Could not access camera or gallery. Please check permissions.'),
        ),
      );
    }
    return null;
  }
}

/// A reusable document upload card widget.
/// Displays an empty upload state or an image preview with replace/remove actions.
class DocumentSlotCard extends StatelessWidget {
  const DocumentSlotCard({
    super.key,
    required this.label,
    required this.image,
    required this.onPick,
    this.onRemove,
    this.errorText,
    this.enabled = true,
  });

  /// Label shown beneath or on top of the slot (e.g. "License (front side)").
  final String label;

  /// Currently selected image file, if any.
  final File? image;

  /// Callback when user wants to pick/replace an image.
  final VoidCallback onPick;

  /// Callback when user removes the currently selected image.
  final VoidCallback? onRemove;

  /// Optional validation error text.
  final String? errorText;

  /// Whether user interaction is allowed.
  final bool enabled;

  /// Shows the selected image in a full-screen zoomable dialog.
  void _viewFullImage(BuildContext context) {
    if (image == null) return;
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                child: Image.file(image!, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1.15,
          child: Material(
            color: AppColors.fieldFill,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.5 : 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: image == null
                ? InkWell(
                    onTap: enabled ? onPick : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 26,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload Photo',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image preview that can be tapped to enlarge
                      InkWell(
                        onTap: () => _viewFullImage(context),
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                          cacheWidth: 600,
                        ),
                      ),
                      // Action buttons: Replace and Delete
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ActionButton(
                              icon: Icons.sync,
                              tooltip: 'Replace photo',
                              onTap: enabled ? onPick : null,
                            ),
                            if (onRemove != null) ...[
                              const SizedBox(width: 6),
                              _ActionButton(
                                icon: Icons.close,
                                tooltip: 'Remove photo',
                                onTap: enabled ? onRemove : null,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

/// A circular semi-transparent overlay action button used on image preview.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(alpha: 0.65),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}