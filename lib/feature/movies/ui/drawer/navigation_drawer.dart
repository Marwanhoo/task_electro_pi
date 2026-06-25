import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/core/constants/app_assets.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';
import 'package:task_electro_pi/feature/logout/ui/logout_dialog.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_cubit.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_state.dart';
import 'package:task_electro_pi/feature/theme/cubit/theme_cubit.dart';
import 'package:task_electro_pi/feature/theme/cubit/theme_state.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<SessionCubit, SessionState>(
              builder: (sessionContext, sessionState) {
                if (sessionState.isAuthenticated) {
                  final username = sessionState.username ?? 'Account';
                  return UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: AppColors.tmdbBlue),
                    accountName: Text(
                      username,
                      style: const TextStyle(
                        color: AppColors.onBrand,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    accountEmail: const Text(
                      'TMDB Member',
                      style: TextStyle(color: AppColors.onBrand),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: AppColors.onBrand,
                      child: Text(
                        username.isNotEmpty
                            ? username[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: AppColors.tmdbBlue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    onDetailsPressed: () => Navigator.of(sessionContext).pop(),
                  );
                }

                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.tmdbBlue),
                  accountName: const Text(
                    'Guest',
                    style: TextStyle(
                      color: AppColors.onBrand,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  accountEmail: const Text(
                    'Sign in to save favorites',
                    style: TextStyle(color: AppColors.onBrand),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: AppColors.onBrand,
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.tmdbBlue,
                    ),
                  ),
                  onDetailsPressed: () {
                    Navigator.of(sessionContext).pop();
                    sessionContext.push('/login');
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/settings');
              },
            ),
            BlocBuilder<SessionCubit, SessionState>(
              builder: (sessionContext, sessionState) {
                if (!sessionState.isAuthenticated) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: const Text('Favorites'),
                      onTap: () {
                        Navigator.of(sessionContext).pop();
                        sessionContext.push('/favorites');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log out'),
                      onTap: () {
                        Navigator.of(sessionContext).pop();
                        showLogoutDialog(sessionContext);
                      },
                    ),
                  ],
                );
              },
            ),
            const Divider(),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (builderContext, themeState) {
                final themeCubit = builderContext.read<ThemeCubit>();
                return SwitchListTile(
                  secondary: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Dark theme'),
                  subtitle: const Text('Enable dark theme'),
                  value: themeCubit.isDarkMode,
                  onChanged: (isEnabled) => themeCubit.toggleThemeMode(),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                AppAssets.tmdbLogo,
                height: 18,
                color: AppColors.tmdbBlue,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
