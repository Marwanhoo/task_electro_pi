import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/app_cache.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/theme/cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeInitial());

  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> toggleThemeMode() async {
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeModeChanged(themeMode));
    await saveThemeMode(themeMode);
  }

  Future<void> saveThemeMode(ThemeMode selectedThemeMode) async {
    await AppCache.setBool(
      key: AppStrings.darkModeKey,
      value: selectedThemeMode == ThemeMode.dark,
    );
  }

  void loadThemeMode() {
    final isDarkModeSaved = AppCache.getBool(key: AppStrings.darkModeKey);
    if (isDarkModeSaved != null) {
      themeMode = isDarkModeSaved ? ThemeMode.dark : ThemeMode.light;
    } else {
      final platformBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      themeMode =
          platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }
    emit(ThemeModeChanged(themeMode));
  }
}
