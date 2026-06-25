import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/constants/app_assets.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';

class TmdbAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmdbAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.tmdbNavy,
      foregroundColor: Colors.white,
      title: Image.asset(
        AppAssets.tmdbLogo,
        height: 22,
        errorBuilder: (context, error, stackTrace) => const Text(
          'TMDB',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
