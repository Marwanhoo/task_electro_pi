import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_electro_pi/core/utils/go_router_refresh_notifier.dart';
import 'package:task_electro_pi/core/utils/service_locator.dart';
import 'package:task_electro_pi/feature/favorites/ui/favorites_screen.dart';
import 'package:task_electro_pi/feature/movies/ui/home_screen.dart';
import 'package:task_electro_pi/feature/movies/ui/movie_details_route_args.dart';
import 'package:task_electro_pi/feature/movies/ui/movie_details_screen.dart';
import 'package:task_electro_pi/feature/search/ui/search_screen.dart';
import 'package:task_electro_pi/feature/search/viewmodel/search_cubit.dart';
import 'package:task_electro_pi/feature/settings/ui/settings_screen.dart';
import 'package:task_electro_pi/feature/signin/ui/login_screen.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/login_cubit.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_cubit.dart';

late final GoRouter appRouter;

String? authRedirect(SessionCubit sessionCubit, GoRouterState state) {
  final isAuthenticated = sessionCubit.state.isAuthenticated;
  final location = state.matchedLocation;

  if (!isAuthenticated && location == '/favorites') {
    return '/login?redirect=${Uri.encodeComponent(location)}';
  }

  if (isAuthenticated && location == '/login') {
    final redirect = state.uri.queryParameters['redirect'];
    if (redirect != null && redirect.isNotEmpty) {
      return redirect;
    }
    return '/';
  }

  return null;
}

GoRouter createAppRouter(SessionCubit sessionCubit) {
  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshNotifier(sessionCubit.stream),
    redirect: (context, state) => authRedirect(sessionCubit, state),
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/details',
        name: 'details',
        pageBuilder: (context, state) {
          final routeArgs = MovieDetailsRouteArgs.fromExtra(state.extra);
          return buildFadeSlidePage(
            state: state,
            child: MovieDetailsScreen(
              movie: routeArgs.movie,
              heroTag: routeArgs.heroTag,
            ),
          );
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        pageBuilder: (context, state) => buildFadeSlidePage(
          state: state,
          child: BlocProvider<SearchCubit>(
            create: (providerContext) => getIt<SearchCubit>(),
            child: const SearchScreen(),
          ),
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
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => buildFadeSlidePage(
          state: state,
          child: BlocProvider<LoginCubit>(
            create: (providerContext) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        pageBuilder: (context, state) => buildFadeSlidePage(
          state: state,
          child: const FavoritesScreen(),
        ),
      ),
    ],
  );
}

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
