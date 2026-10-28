import 'package:star_drive/features/theme/data/datasource/theme_local_datasource.dart';

import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/theme_repository.dart';


class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl(this.localDataSource);

  @override
  AppThemeMode getThemeMode() {
    final savedMode = localDataSource.getThemeMode();

    return savedMode == 'dark'
        ? AppThemeMode.dark
        : AppThemeMode.light;
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) {
    return localDataSource.saveThemeMode(mode.name);
  }
}