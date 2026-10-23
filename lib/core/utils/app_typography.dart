import 'package:material_ui/material_ui.dart';

import 'screen_dimensions.dart';

class AppTypography {
  AppTypography._();

  // Font size tokens
  static const double fontCaption = 12;
  static const double fontBody = 14;
  static const double fontSubtitle = 16;
  static const double fontTitle = 20;
  static const double fontHeading = 24;

  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  /// Koi bhi custom responsive style
  static TextStyle custom(
    BuildContext context,
    double fontSize, {
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontSize: ScreenDimensions.responsiveFontSize(context, fontSize),
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle heading(BuildContext c, {Color? color}) =>
      custom(c, fontHeading, fontWeight: bold, color: color);

  static TextStyle title(BuildContext c, {Color? color}) =>
      custom(c, fontTitle, fontWeight: semiBold, color: color);

  static TextStyle subtitle(BuildContext c, {Color? color}) =>
      custom(c, fontSubtitle, fontWeight: medium, color: color);

  static TextStyle body(BuildContext c, {Color? color}) =>
      custom(c, fontBody, fontWeight: regular, color: color);

  static TextStyle caption(BuildContext c, {Color? color}) =>
      custom(c, fontCaption, fontWeight: regular, color: color);

  static TextStyle button(BuildContext c, {Color? color}) =>
      custom(c, fontSubtitle, fontWeight: semiBold, color: color);
}

extension AppTypographyExtension on BuildContext {
  TextStyle get headingStyle => AppTypography.heading(this);
  TextStyle get titleStyle => AppTypography.title(this);
  TextStyle get subtitleStyle => AppTypography.subtitle(this);
  TextStyle get bodyStyle => AppTypography.body(this);
  TextStyle get captionStyle => AppTypography.caption(this);
  TextStyle get buttonStyle => AppTypography.button(this);

  TextStyle responsiveTextStyle(
    double fontSize, {
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) =>
      AppTypography.custom(
        this,
        fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      );
}