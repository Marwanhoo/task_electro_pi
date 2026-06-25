import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/ui/home_screen.dart';
import 'package:task_electro_pi/feature/movies/ui/movie_details_screen.dart';
import 'package:task_electro_pi/feature/settings/ui/settings_screen.dart';

final GoRouter routerConfig = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      name: 'details',
      pageBuilder: (context, state) => buildFadeSlidePage(
        state: state,
        child: MovieDetailsScreen(movie: state.extra as MovieModel),
      ),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) => buildFadeSlidePage(
        state: state,
        child: const SettingsScreen(),
      ),
    ),
  ],
);

CustomTransitionPage<void> buildFadeSlidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, pageChild) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: pageChild,
        ),
      );
    },
  );
}
