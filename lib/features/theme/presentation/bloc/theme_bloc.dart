import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:star_drive/features/theme/domain/entities/app_theme_mode.dart';
import 'package:star_drive/features/theme/domain/usecases/get_theme_mode.dart';
import 'package:star_drive/features/theme/domain/usecases/save_theme_mode.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SaveThemeMode saveThemeMode;

  ThemeBloc({
    required GetThemeMode getThemeMode,
    required this.saveThemeMode,
  }) : super(
          ThemeState(
            mode: getThemeMode() == AppThemeMode.dark
                ? ThemeMode.dark
                : ThemeMode.light,
          ),
        ) {
    on<ThemeModeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeChanged(
    ThemeModeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    final previousMode = state.mode;

    final selectedMode = event.mode == ThemeMode.dark
        ? AppThemeMode.dark
        : AppThemeMode.light;

    try {
      // Pehle selected theme Hive mein save hogi.
      await saveThemeMode(selectedMode);

      // Save hone ke baad app ki theme change hogi.
      emit(ThemeState(mode: event.mode));
    } catch (_) {
      // Save fail ho to purani theme preserve rahegi.
      emit(
        ThemeState(
          mode: previousMode,
          errorMessage: 'Could not save theme preference.',
        ),
      );
    }
  }
}