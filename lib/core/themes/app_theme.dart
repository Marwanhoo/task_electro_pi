import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';
import 'package:task_electro_pi/core/themes/theme_text.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme = buildTheme(Brightness.light);

  static ThemeData darkTheme = buildTheme(Brightness.dark);

  static ThemeData buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.tmdbBlue,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.tmdbBlue,
      secondary: AppColors.tmdbBlue,
      surface: isDark ? AppColors.tmdbDarkSurface : AppColors.tmdbLightBackground,
    );

    final scaffoldBackgroundColor =
        isDark ? AppColors.tmdbDarkBackground : AppColors.tmdbLightBackground;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: ThemeText.poppinsTextThemeOf(brightness),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
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
}
