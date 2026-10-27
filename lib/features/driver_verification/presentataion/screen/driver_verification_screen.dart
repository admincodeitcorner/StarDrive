import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/core/di/injector.dart';
import 'package:star_drive/features/dashboard/presentation/screens/home.screen.dart';
import 'package:star_drive/features/driver_verification/domain/entities/document_file.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_document.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/driver_verification_bloc/driver_verification_bloc.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/cnic_photo-screen.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/vechile_detail_screen.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/document_slot.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/document_slot_row.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/verification_section_header.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/verification_text_field.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/verification_tips_card.dart';

// ============================================================================
// STEP 1: DRIVING LICENSE SCREEN
// ============================================================================


class DriverVerificationScreen extends StatelessWidget {
  const DriverVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DriverVerificationBloc? existingBloc;
    try {
      existingBloc = BlocProvider.of<DriverVerificationBloc>(context, listen: false);
    } catch (_) {
      existingBloc = null;
    }

    if (existingBloc != null) {
      return const _DriverVerificationScreenView();
    }

    return BlocProvider<DriverVerificationBloc>(
      create: (_) => sl<DriverVerificationBloc>(),
      child: const _DriverVerificationScreenView(),
    );
  }
}

class _DriverVerificationScreenView extends StatefulWidget {
  const _DriverVerificationScreenView();

  @override
  State<_DriverVerificationScreenView> createState() => _DriverVerificationScreenViewState();
}

class _DriverVerificationScreenViewState extends State<_DriverVerificationScreenView> {
  File? _licenseFrontImage;
  File? _licenseBackImage;

  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _licenseExpiryController = TextEditingController();

  DateTime? _licenseExpiryDate;
  bool _showLicenseErrors = false;

  @override
  void dispose() {
    _licenseNumberController.dispose();
    _licenseExpiryController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _pickExpiryDate() async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final initial = _licenseExpiryDate ?? now.add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now,
      lastDate: DateTime(now.year + 30),
      helpText: 'Select License Expiry Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _licenseExpiryDate = picked;
        _licenseExpiryController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _handlePickImage(Function(File) onSelected) async {
    final file = await pickDocumentImage(context);
    if (file != null) {
      setState(() {
        onSelected(file);
      });
    }
  }

  bool _isLicenseValid() {
    final isLicenseNumberValid = _licenseNumberController.text.trim().length >= 3;
    final isExpiryValid = _licenseExpiryDate != null;
    final hasLicensePhotos = _licenseFrontImage != null && _licenseBackImage != null;
    return isLicenseNumberValid && isExpiryValid && hasLicensePhotos;
  }

  int get _licensePhotosCount {
    var count = 0;
    if (_licenseFrontImage != null) count++;
    if (_licenseBackImage != null) count++;
    return count;
  }

  void _onNext() {
    FocusScope.of(context).unfocus();
    setState(() {
      _showLicenseErrors = true;
    });

    if (!_isLicenseValid()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Please upload both license photos and fill in required details.'),
          ),
        );
      return;
    }

    final bloc = context.read<DriverVerificationBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: CnicVerificationScreen(
            licenseFrontImage: _licenseFrontImage!,
            licenseBackImage: _licenseBackImage!,
            licenseNumber: _licenseNumberController.text.trim(),
            licenseExpiryDate: _licenseExpiryDate!,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Driver Verification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // // Step 1 of 2 indicator
            // const StepProgressTabs(currentStep: 1),
            // const Divider(height: 1, thickness: 1, color: AppColors.border),

            // Form inputs
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DocumentUploadProgress(
                      title: 'Upload Driving License',
                      subtitle: 'Upload photos and enter your license details.',
                      uploadedCount: _licensePhotosCount,
                      totalCount: 2,
                    ),
                    const SizedBox(height: 24),
                    const VerificationSectionHeader(
                      stepNumber: 1,
                      title: 'Driving License',
                      subtitle: 'Upload clear photos of both sides and enter details',
                    ),
                    const SizedBox(height: 14),
                    DocumentSlotRow(
                      frontLabel: 'License (Front Side)',
                      frontImage: _licenseFrontImage,
                      onPickFront: () => _handlePickImage((file) => _licenseFrontImage = file),
                      onRemoveFront: () => setState(() => _licenseFrontImage = null),
                      frontError: _showLicenseErrors && _licenseFrontImage == null
                          ? 'Front photo required'
                          : null,
                      backLabel: 'License (Back Side)',
                      backImage: _licenseBackImage,
                      onPickBack: () => _handlePickImage((file) => _licenseBackImage = file),
                      onRemoveBack: () => setState(() => _licenseBackImage = null),
                      backError: _showLicenseErrors && _licenseBackImage == null
                          ? 'Back photo required'
                          : null,
                      enabled: true,
                    ),
                    const SizedBox(height: 18),
                    VerificationTextField(
                      controller: _licenseNumberController,
                      label: 'License Number',
                      hint: 'e.g. DL-12345678',
                      prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textSecondary),
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      errorText: _showLicenseErrors &&
                              _licenseNumberController.text.trim().length < 3
                          ? 'Please enter a valid license number'
                          : null,
                      onChanged: (_) {
                        if (_showLicenseErrors) setState(() {});
                      },
                    ),
                    const SizedBox(height: 14),
                    VerificationTextField(
                      controller: _licenseExpiryController,
                      label: 'License Expiry Date',
                      hint: 'Select expiry date (DD/MM/YYYY)',
                      prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary),
                      suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      readOnly: true,
                      enabled: true,
                      onTap: _pickExpiryDate,
                      errorText: _showLicenseErrors && _licenseExpiryDate == null
                          ? 'Please select license expiry date'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    const VerificationTipsCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Next button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next: CNIC Verification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// STEP 2: NATIONAL IDENTITY CARD (CNIC) SCREEN
// ============================================================================

/// Screen 2: Receives driving license details in its constructor.
/// Collects CNIC photos and dispatches [SendDocument] with all documents.

// ============================================================================
// SHARED HELPER COMPONENTS
// ============================================================================

/// Two-step progress tabs showing active and completed states.
class StepProgressTabs extends StatelessWidget {
  const StepProgressTabs({
    super.key,
    required this.currentStep,
  });

  final int currentStep; // 1 for License, 2 for CNIC

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _StepTabItem(
              stepNumber: 1,
              title: 'Driving License',
              isActive: currentStep == 1,
              isCompleted: currentStep > 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: 20,
              height: 2,
              color: currentStep > 1 ? AppColors.primary : AppColors.border,
            ),
          ),
          Expanded(
            child: _StepTabItem(
              stepNumber: 2,
              title: 'National ID (CNIC)',
              isActive: currentStep == 2,
              isCompleted: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom tab indicator item for the step progress header.
class _StepTabItem extends StatelessWidget {
  const _StepTabItem({
    required this.stepNumber,
    required this.title,
    required this.isActive,
    required this.isCompleted,
  });

  final int stepNumber;
  final String title;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? AppColors.primary
        : (isCompleted ? Colors.green.shade300 : AppColors.border);
    final bgColor = isActive
        ? AppColors.primary.withValues(alpha: 0.08)
        : (isCompleted ? Colors.green.withValues(alpha: 0.06) : AppColors.fieldFill);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isActive ? 1.5 : 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? Colors.green
                  : (isActive ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3)),
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 13, color: Colors.white)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color: isActive ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header banner displaying the title, subtitle, and current uploaded document count badge.
class DocumentUploadProgress extends StatelessWidget {
  const DocumentUploadProgress({
    super.key,
    required this.title,
    required this.subtitle,
    required this.uploadedCount,
    required this.totalCount,
  });

  final String title;
  final String subtitle;
  final int uploadedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final isComplete = uploadedCount == totalCount && totalCount > 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isComplete
                  ? Colors.green.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$uploadedCount/$totalCount Photos',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isComplete ? Colors.green.shade800 : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
