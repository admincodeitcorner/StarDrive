import 'package:material_ui/material_ui.dart';

/// Screen type
enum ScreenType { mobile, tablet, desktop }


class AppBreakpoints {
  AppBreakpoints._();

  static const double tablet = 600; // tablet
  static const double desktop = 1024; // desktop

  static ScreenType typeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktop) return ScreenType.desktop;
    if (width >= tablet) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      typeOf(context) == ScreenType.mobile;

  static bool isTablet(BuildContext context) =>
      typeOf(context) == ScreenType.tablet;

  static bool isDesktop(BuildContext context) =>
      typeOf(context) == ScreenType.desktop;

  
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (typeOf(context)) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }
}

extension AppBreakpointsExtension on BuildContext {
  ScreenType get screenType => AppBreakpoints.typeOf(this);

  bool get isMobileLayout => AppBreakpoints.isMobile(this);
  bool get isTabletLayout => AppBreakpoints.isTablet(this);
  bool get isDesktopLayout => AppBreakpoints.isDesktop(this);

  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) =>
      AppBreakpoints.value(this, mobile: mobile, tablet: tablet, desktop: desktop);
}