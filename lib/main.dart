import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/themes/app_theme.dart';
import 'package:task_electro_pi/core/utils/app_router.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/core/utils/my_bloc_observer.dart';
import 'package:task_electro_pi/core/utils/service_locator.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_cubit.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_cubit.dart';
import 'package:task_electro_pi/feature/theme/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await setupServiceLocator();
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<ThemeCubit>(
          create: (providerContext) => ThemeCubit()..loadThemeMode(),
        ),
        BlocProvider<SessionCubit>(
          create: (providerContext) => getIt<SessionCubit>()..loadSession(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (providerContext) {
            final favoritesCubit = getIt<FavoritesCubit>();
            if (getIt<SessionCubit>().state.isAuthenticated) {
              favoritesCubit.loadFavoritesIfNeeded();
            }
            return favoritesCubit;
          },
        ),
      ],
      child: Builder(
        builder: (builderContext) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appTitle,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: builderContext.watch<ThemeCubit>().themeMode,
            themeAnimationStyle: AnimationStyle(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
            ),
            routerConfig: routerConfig,
          );
        },
      ),
    );
  }
}
