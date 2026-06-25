import 'package:flutter/material.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

class ThemeModeChanged extends ThemeState {
  final ThemeMode themeMode;

  const ThemeModeChanged(this.themeMode);
}
