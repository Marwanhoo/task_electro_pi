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

  static String movieCreditsEndpoint(int movieId) => 'movie/$movieId/credits';
  static String movieVideosEndpoint(int movieId) => 'movie/$movieId/videos';
  static String movieSimilarEndpoint(int movieId) => 'movie/$movieId/similar';
  static String movieRecommendationsEndpoint(int movieId) =>
      'movie/$movieId/recommendations';
  static const String youtubeWatchBaseUrl = 'https://www.youtube.com/watch?v=';

  static const String requestTokenEndpoint = 'authentication/token/new';
  static const String validateLoginEndpoint =
      'authentication/token/validate_with_login';
  static const String createSessionEndpoint = 'authentication/session/new';
  static const String deleteSessionEndpoint = 'authentication/session';
  static const String accountEndpoint = 'account';

  static String favoriteMoviesEndpoint(int accountId) =>
      'account/$accountId/favorite/movies';

  static String favoriteEndpoint(int accountId) => 'account/$accountId/favorite';

  static const String sessionIdKey = 'session_id';
  static const String accountIdKey = 'account_id';
  static const String usernameKey = 'username';
  static const String savedUsernameKey = 'saved_username';
  static const String savedPasswordKey = 'saved_password';

  static const String defaultUsername = 'mohamedmohamed2023';
  static const String defaultPassword = r'*x0c7My)1z+$';

  static const String cacheTrendingKey = 'cache_trending_movies';
  static const String cachePopularKey = 'cache_popular_movies';
  static const String cacheNowPlayingKey = 'cache_now_playing_movies';
  static const String cacheComingSoonKey = 'cache_coming_soon_movies';

  static const String darkModeKey = 'is_dark_mode';
}
