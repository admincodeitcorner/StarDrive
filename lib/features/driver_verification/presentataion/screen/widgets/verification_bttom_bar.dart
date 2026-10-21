import 'package:flutter/material.dart';
import 'package:star_drive/core/constant/app_colors.dart';

/// Reusable bottom bar showing progress and navigation buttons for multi-step flows.
class VerificationBottomBar extends StatelessWidget {
  const VerificationBottomBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isLoading,
    required this.onNext,
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final bool isLoading;
  final VoidCallback onNext;

  /// Null on the first step (button hidden).
  final VoidCallback? onBack;

  bool get _isLast => currentStep == totalSteps;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$currentStep of $totalSteps',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: currentStep / totalSteps),
                    duration: const Duration(milliseconds: 300),
                    builder: (_, value, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                        backgroundColor: AppColors.border,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (onBack != null) ...[
              SizedBox(
                width: 52,
                height: 52,
                child: Material(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: isLoading ? null : onBack,
                    child: const Icon(Icons.chevron_left,
                        color: AppColors.textPrimary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 112),
              child: SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: isLoading ? null : onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.6),
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: AppColors.textPrimary),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isLast ? 'Submit' : 'Next',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            if (!_isLast) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, size: 20),
                            ],
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