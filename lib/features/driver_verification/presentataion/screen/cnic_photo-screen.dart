import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/core/constant/app_colors.dart';
import 'package:star_drive/features/driver_verification/domain/entities/document_file.dart';
import 'package:star_drive/features/driver_verification/domain/entities/driver_document.dart';
import 'package:star_drive/features/driver_verification/presentataion/bloc/driver_verification_bloc/driver_verification_bloc.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/driver_verification_screen.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/vechile_detail_screen.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/vechile_picture_screen.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/document_slot_row.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/verification_section_header.dart';
import 'package:star_drive/features/driver_verification/presentataion/screen/widgets/verification_tips_card.dart';

class CnicVerificationScreen extends StatefulWidget {
  const CnicVerificationScreen({
    super.key,
    required this.licenseFrontImage,
    required this.licenseBackImage,
    required this.licenseNumber,
    required this.licenseExpiryDate,
  });

  final File licenseFrontImage;
  final File licenseBackImage;
  final String licenseNumber;
  final DateTime licenseExpiryDate;

  @override
  State<CnicVerificationScreen> createState() => _CnicVerificationScreenState();
}

class _CnicVerificationScreenState extends State<CnicVerificationScreen> {
  File? _cnicFrontImage;
  File? _cnicBackImage;
  bool _showCnicErrors = false;

  int get _cnicPhotosCount {
    var count = 0;
    if (_cnicFrontImage != null) count++;
    if (_cnicBackImage != null) count++;
    return count;
  }

  Future<void> _handlePickImage(Function(File) onSelected) async {
    final file = await pickDocumentImage(context);
    if (file != null) {
      setState(() {
        onSelected(file);
      });
    }
  }

  void _onSubmit(bool isLoading) {
    if (isLoading) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _showCnicErrors = true;
    });

    if (_cnicFrontImage == null || _cnicBackImage == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Please upload both front and back photos of your CNIC.'),
          ),
        );
        
      return;
    }

    // Build entity payload with all documents from Step 1 (constructor) and Step 2
    final documents = DriverDocuments(
      licenseNumber: widget.licenseNumber,
      licenseExpiryDate: widget.licenseExpiryDate,
      licenseFrontPic: DocumentFile(
        path: widget.licenseFrontImage.path,
        fileName: widget.licenseFrontImage.uri.pathSegments.isNotEmpty
            ? widget.licenseFrontImage.uri.pathSegments.last
            : null,
      ),
      licenseBackPic: DocumentFile(
        path: widget.licenseBackImage.path,
        fileName: widget.licenseBackImage.uri.pathSegments.isNotEmpty
            ? widget.licenseBackImage.uri.pathSegments.last
            : null,
      ),
      cnicFrontPic: DocumentFile(
        path: _cnicFrontImage!.path,
        fileName: _cnicFrontImage!.uri.pathSegments.isNotEmpty
            ? _cnicFrontImage!.uri.pathSegments.last
            : null,
      ),
      cnicBackPic: DocumentFile(
        path: _cnicBackImage!.path,
        fileName: _cnicBackImage!.uri.pathSegments.isNotEmpty
            ? _cnicBackImage!.uri.pathSegments.last
            : null,
      ),
    );

    // Dispatch event to BLoC
    context.read<DriverVerificationBloc>().add(SendDocument(documents));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverVerificationBloc, DriverVerificationState>(
      listener: (context, state) {
        if (state is DriverVerificationFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: AppColors.error,
                content: Text(state.message),
              ),
            );
        } else if (state is DriverVerificationSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Documents submitted successfully! Verification is in progress.'),
              ),
            );
          
        Navigator.push(context, MaterialPageRoute(builder: (_)=>VechileDetailScreen()));
        }
      },
      builder: (context, state) {
        final isLoading = state is DriverVerificationLoading;
        final enabled = !isLoading;

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
              onPressed: enabled ? () => Navigator.maybePop(context) : null,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Step 2 of 2 indicator
                const StepProgressTabs(currentStep: 2),
                const Divider(height: 1, thickness: 1, color: AppColors.border),

                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DocumentUploadProgress(
                          title: 'Upload Identity Card (CNIC)',
                          subtitle: 'Upload clear photos of both sides of your CNIC.',
                          uploadedCount: _cnicPhotosCount,
                          totalCount: 2,
                        ),
                        const SizedBox(height: 24),
                        const VerificationSectionHeader(
                          stepNumber: 2,
                          title: 'National Identity Card (CNIC)',
                          subtitle: 'Upload clear photos of both sides of your CNIC',
                        ),
                        const SizedBox(height: 14),
                        DocumentSlotRow(
                          frontLabel: 'CNIC (Front Side)',
                          frontImage: _cnicFrontImage,
                          onPickFront: () => _handlePickImage((file) => _cnicFrontImage = file),
                          onRemoveFront: () => setState(() => _cnicFrontImage = null),
                          frontError: _showCnicErrors && _cnicFrontImage == null
                              ? 'Front photo required'
                              : null,
                          backLabel: 'CNIC (Back Side)',
                          backImage: _cnicBackImage,
                          onPickBack: () => _handlePickImage((file) => _cnicBackImage = file),
                          onRemoveBack: () => setState(() => _cnicBackImage = null),
                          backError: _showCnicErrors && _cnicBackImage == null
                              ? 'Back photo required'
                              : null,
                          enabled: enabled,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom bar with Back and Submit Documents button
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
                  child: Row(
                    children: [
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: Material(
                          color: AppColors.fieldFill,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: enabled ? () => Navigator.maybePop(context) : null,
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: isLoading ? null : () => _onSubmit(isLoading),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.verified_outlined, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Submit Documents',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
