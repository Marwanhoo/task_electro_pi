import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';

class MoviesResultModel {
  final int page;
  final List<MovieModel> movies;
  final int totalPages;
  final int totalResults;

  const MoviesResultModel({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResultModel.fromJson(Map<String, dynamic> json) {
    final resultsJson = json['results'] as List<dynamic>? ?? <dynamic>[];
    return MoviesResultModel(
      page: json['page'] ?? 0,
      movies: resultsJson
          .map((movieJson) =>
              MovieModel.fromJson(movieJson as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }

  static List<MovieModel> moviesFromRawList(List<dynamic> rawList) {
    return rawList
        .map((movieJson) =>
            MovieModel.fromJson(movieJson as Map<String, dynamic>))
        .toList();
  }
}
