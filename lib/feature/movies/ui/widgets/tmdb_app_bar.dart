import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/constants/app_assets.dart';

class TmdbAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmdbAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        AppAssets.tmdbLogo,
        height: 22,
        errorBuilder: (context, error, stackTrace) => Text(
          'TMDB',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
        ),
      ),
    );
  }
}
