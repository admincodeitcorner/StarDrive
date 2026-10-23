import 'package:material_ui/material_ui.dart';

import 'screen_dimensions.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

extension AppSpacingExtension on BuildContext {
  // ---------- Vertical gaps ----------
  SizedBox get gapXs => SizedBox(height: responsiveHeight(AppSpacing.xs));
  SizedBox get gapSm => SizedBox(height: responsiveHeight(AppSpacing.sm));
  SizedBox get gapMd => SizedBox(height: responsiveHeight(AppSpacing.md));
  SizedBox get gapLg => SizedBox(height: responsiveHeight(AppSpacing.lg));
  SizedBox get gapXl => SizedBox(height: responsiveHeight(AppSpacing.xl));

  // ---------- Horizontal gaps ----------
  SizedBox get gapHXs => SizedBox(width: responsiveWidth(AppSpacing.xs));
  SizedBox get gapHSm => SizedBox(width: responsiveWidth(AppSpacing.sm));
  SizedBox get gapHMd => SizedBox(width: responsiveWidth(AppSpacing.md));
  SizedBox get gapHLg => SizedBox(width: responsiveWidth(AppSpacing.lg));
  SizedBox get gapHXl => SizedBox(width: responsiveWidth(AppSpacing.xl));

  // ---------- Custom gaps ----------
  SizedBox verticalGap(double v) => SizedBox(height: responsiveHeight(v));
  SizedBox horizontalGap(double v) => SizedBox(width: responsiveWidth(v));

  // ---------- Ready-made paddings ----------
  EdgeInsets get pagePadding => symmetricPadding(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      );
  EdgeInsets get cardPadding => allPadding(AppSpacing.md);
  EdgeInsets get itemPadding => symmetricPadding(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      );
}