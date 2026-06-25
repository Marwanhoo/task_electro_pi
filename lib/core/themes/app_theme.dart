import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';
import 'package:task_electro_pi/core/themes/theme_text.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.tmdbLightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.tmdbNavy,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.tmdbNavy,
      secondary: AppColors.tmdbBlue,
    ),
    textTheme: ThemeText.poppinsTextThemeOf(Brightness.light),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.tmdbNavy,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.tmdbNavy,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.tmdbBlue.withValues(alpha: 0.5)
            : null,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? AppColors.tmdbBlue : null,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.tmdbDarkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.tmdbBlue,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.tmdbBlue,
      secondary: AppColors.tmdbBlue,
      surface: AppColors.tmdbDarkSurface,
    ),
    textTheme: ThemeText.poppinsTextThemeOf(Brightness.dark),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.tmdbNavy,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.tmdbDarkSurface,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      textColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.tmdbBlue.withValues(alpha: 0.5)
            : null,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? AppColors.tmdbBlue : null,
      ),
    ),
  );
}
