import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/service_locator.dart';
import 'package:task_electro_pi/feature/movies/ui/drawer/navigation_drawer.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/hero_banner.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/horizontal_movie_list.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/popular_tabs.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/section_header.dart';
import 'package:task_electro_pi/feature/movies/ui/widgets/tmdb_app_bar.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/carousel/movie_carousel_cubit.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/carousel/movie_carousel_state.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/tabbed/movie_tabbed_cubit.dart';
import 'package:task_electro_pi/feature/movies/viewmodel/tabbed/movie_tabbed_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<MovieCarouselCubit>(
          create: (providerContext) =>
              getIt<MovieCarouselCubit>()..loadTrendingMovies(),
        ),
        BlocProvider<MovieTabbedCubit>(
          create: (providerContext) => getIt<MovieTabbedCubit>()..changeTab(0),
        ),
      ],
      child: Scaffold(
        appBar: const TmdbAppBar(),
        drawer: const AppNavigationDrawer(),
        body: Builder(
          builder: (innerContext) => RefreshIndicator(
            onRefresh: () => refreshHomeContent(innerContext),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              children: const <Widget>[
                TrendingSection(),
                PopularSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshHomeContent(BuildContext context) async {
    final movieTabbedCubit = context.read<MovieTabbedCubit>();
    await Future.wait<void>(<Future<void>>[
      context.read<MovieCarouselCubit>().loadTrendingMovies(),
      movieTabbedCubit.changeTab(movieTabbedCubit.state.currentTabIndex),
    ]);
  }
}

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCarouselCubit, MovieCarouselState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeroBanner(featuredMovie: state.featuredMovie),
            const SectionHeader(title: 'Trending'),
            buildTrendingContent(context, state),
          ],
        );
      },
    );
  }

  Widget buildTrendingContent(BuildContext context, MovieCarouselState state) {
    switch (state.status) {
      case MovieCarouselStatus.success:
        return HorizontalMovieList(movies: state.movies);
      case MovieCarouselStatus.failure:
        return MessagePlaceholder(
          message: state.errorMessage ?? 'Could not load trending movies',
        );
      case MovieCarouselStatus.initial:
      case MovieCarouselStatus.loading:
        return const LoadingPlaceholder();
    }
  }
}

class PopularSection extends StatelessWidget {
  const PopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieTabbedCubit, MovieTabbedState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionHeader(title: "What's Popular"),
            PopularTabs(
              selectedTabIndex: state.currentTabIndex,
              onTabSelected: (tabIndex) =>
                  context.read<MovieTabbedCubit>().changeTab(tabIndex),
            ),
            const SizedBox(height: 12),
            buildPopularContent(context, state),
          ],
        );
      },
    );
  }

  Widget buildPopularContent(BuildContext context, MovieTabbedState state) {
    switch (state.status) {
      case MovieTabbedStatus.success:
        return HorizontalMovieList(movies: state.movies);
      case MovieTabbedStatus.failure:
        return MessagePlaceholder(
          message: state.errorMessage ?? 'Could not load movies',
        );
      case MovieTabbedStatus.initial:
      case MovieTabbedStatus.loading:
        return const LoadingPlaceholder();
    }
  }
}

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 290,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class MessagePlaceholder extends StatelessWidget {
  const MessagePlaceholder({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
