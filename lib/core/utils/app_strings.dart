class AppStrings {
  AppStrings._();

  static const String appTitle = 'Movie App';

  static const String baseUrl = 'https://api.themoviedb.org/3/';
  static const String apiKey = 'b95ffcad57714c9f3f97d104e9584931';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static const String trendingEndpoint = 'trending/movie/day';
  static const String popularEndpoint = 'movie/popular';
  static const String nowPlayingEndpoint = 'movie/now_playing';
  static const String comingSoonEndpoint = 'movie/upcoming';
  static const String searchMovieEndpoint = 'search/movie';

  static const String cacheTrendingKey = 'cache_trending_movies';
  static const String cachePopularKey = 'cache_popular_movies';
  static const String cacheNowPlayingKey = 'cache_now_playing_movies';
  static const String cacheComingSoonKey = 'cache_coming_soon_movies';

  static const String darkModeKey = 'is_dark_mode';
}
