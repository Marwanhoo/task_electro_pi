import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme poppinsTextThemeOf(Brightness brightness) {
    final baseTextTheme = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    return GoogleFonts.poppinsTextTheme(baseTextTheme);
  }
}

extension ThemeTextExtension on TextTheme {
  TextStyle get royalBlueSubTitle => titleMedium!.copyWith(
        color: AppColors.royalBlue,
        fontWeight: FontWeight.w600,
      );
}
