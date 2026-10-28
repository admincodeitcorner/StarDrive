import 'package:hive_ce/hive.dart';

class ThemeLocalDataSource {
  final Box<String> settingsBox;

  ThemeLocalDataSource(this.settingsBox);

  static const String _themeKey = 'app_theme_mode';

  String? getThemeMode() {
    return settingsBox.get(_themeKey);
  }

  Future<void> saveThemeMode(String mode) async {
    await settingsBox.put(_themeKey, mode);
  }
}