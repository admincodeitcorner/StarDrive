import '../entities/app_theme_mode.dart';

abstract class ThemeRepository {
  AppThemeMode getThemeMode();

  Future<void> saveThemeMode(AppThemeMode mode);
}