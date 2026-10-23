
import 'dart:math' as math;

import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:material_ui/material_ui.dart';

class ScreenDimensions {
  ScreenDimensions._();

  // Scaling limits
  static const double maxScale = 1.4;
  static const double maxTextScale = 1.2;

  // Spacing tokens
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // Border radius tokens
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;

  // Typography tokens
  static const double fontCaption = 12;
  static const double fontBody = 14;
  static const double fontSubtitle = 16;
  static const double fontTitle = 20;
  static const double fontHeading = 24;

  // Icon size tokens
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;

  // Component dimensions
  static const double buttonHeight = 48;

  // Internal scaling helper
  static double _capScale(
    double scaledValue,
    double originalValue,
    double maximumScale,
  ) {
    return math.min(scaledValue, originalValue * maximumScale);
  }

  // Responsive dimensions

  static double responsiveWidth(
    BuildContext context,
    double designWidth,
  ) {
    return _capScale(
      context.w(designWidth),
      designWidth,
      maxScale,
    );
  }

  static double responsiveHeight(
    BuildContext context,
    double designHeight,
  ) {
    return _capScale(
      context.h(designHeight),
      designHeight,
      maxScale,
    );
  }

  static double responsiveRadius(
    BuildContext context,
    double designRadius,
  ) {
    return _capScale(
      context.r(designRadius),
      designRadius,
      maxScale,
    );
  }

  static double responsiveFontSize(
    BuildContext context,
    double designFontSize,
  ) {
    return _capScale(
      context.sp(designFontSize),
      designFontSize,
      maxTextScale,
    );
  }

  static double responsiveIconSize(
    BuildContext context,
    double designIconSize,
  ) {
    return _capScale(
      context.r(designIconSize),
      designIconSize,
      maxScale,
    );
  }

  // Padding helpers

  static EdgeInsets allPadding(
    BuildContext context, {
    double value = spaceMd,
  }) {
    return EdgeInsets.all(responsiveRadius(context, value));
  }

  static EdgeInsets symmetricPadding(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: responsiveWidth(context, horizontal),
      vertical: responsiveHeight(context, vertical),
    );
  }

  static EdgeInsets onlyPadding(
    BuildContext context, {
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: responsiveWidth(context, left),
      top: responsiveHeight(context, top),
      right: responsiveWidth(context, right),
      bottom: responsiveHeight(context, bottom),
    );
  }

  // Border radius

  static BorderRadius circularBorderRadius(
    BuildContext context, {
    double value = radiusMd,
  }) {
    return BorderRadius.circular(
      responsiveRadius(context, value),
    );
  }

  // Screen information

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  // Layout breakpoints

  static bool isMobileLayout(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  static bool isTabletLayout(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 600 && width < 1024;
  }

  static bool isDesktopLayout(BuildContext context) {
    return getScreenWidth(context) >= 1024;
  }

  // Select a value according to the available screen width

  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktopLayout(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (isTabletLayout(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}

// BuildContext extensions

extension ScreenDimensionsExtension on BuildContext {
  double responsiveWidth(double value) =>
      ScreenDimensions.responsiveWidth(this, value);

  double responsiveHeight(double value) =>
      ScreenDimensions.responsiveHeight(this, value);

  double responsiveRadius(double value) =>
      ScreenDimensions.responsiveRadius(this, value);

  double responsiveFontSize(double value) =>
      ScreenDimensions.responsiveFontSize(this, value);

  double responsiveIconSize(double value) =>
      ScreenDimensions.responsiveIconSize(this, value);

  EdgeInsets allPadding(double md, {double value = ScreenDimensions.spaceMd}) =>
      ScreenDimensions.allPadding(this, value: value);

  EdgeInsets symmetricPadding({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      ScreenDimensions.symmetricPadding(
        this,
        horizontal: horizontal,
        vertical: vertical,
      );

  EdgeInsets onlyPadding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      ScreenDimensions.onlyPadding(
        this,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      );

  BorderRadius circularBorderRadius({
    double value = ScreenDimensions.radiusMd,
  }) =>
      ScreenDimensions.circularBorderRadius(this, value: value);

  SizedBox verticalGap(double value) =>
      SizedBox(height: responsiveHeight(value));

  SizedBox horizontalGap(double value) =>
      SizedBox(width: responsiveWidth(value));

  TextStyle responsiveTextStyle(
    double fontSize, {
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: responsiveFontSize(fontSize),
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  bool get isMobileLayout => ScreenDimensions.isMobileLayout(this);

  bool get isTabletLayout => ScreenDimensions.isTabletLayout(this);

  bool get isDesktopLayout => ScreenDimensions.isDesktopLayout(this);
}
