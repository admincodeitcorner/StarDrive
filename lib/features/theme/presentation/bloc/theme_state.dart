import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode mode;
  final String? errorMessage;

  const ThemeState({
    this.mode = ThemeMode.light,
    this.errorMessage,
  });
}