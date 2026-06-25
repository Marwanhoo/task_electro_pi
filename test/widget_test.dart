import 'package:flutter_test/flutter_test.dart';
import 'package:task_electro_pi/feature/movies/data/model/movie_model.dart';
import 'package:task_electro_pi/feature/movies/data/model/movies_result_model.dart';

void main() {
  test('MovieModel.fromJson parses TMDB fields', () {
    final movie = MovieModel.fromJson(<String, dynamic>{
      'id': 550,
      'title': 'Fight Club',
      'poster_path': '/poster.jpg',
      'backdrop_path': '/backdrop.jpg',
      'vote_average': 8.4,
      'vote_count': 1000,
      'release_date': '1999-10-15',
      'overview': 'An insomniac office worker...',
      'original_language': 'en',
      'popularity': 61.4,
    });

    expect(movie.id, 550);
    expect(movie.title, 'Fight Club');
    expect(movie.posterPath, '/poster.jpg');
    expect(movie.voteAverage, 8.4);
  });

  test('MoviesResultModel.fromJson parses the results list', () {
    final result = MoviesResultModel.fromJson(<String, dynamic>{
      'page': 1,
      'results': <Map<String, dynamic>>[
        <String, dynamic>{'id': 1, 'title': 'First'},
        <String, dynamic>{'id': 2, 'title': 'Second'},
      ],
      'total_pages': 10,
      'total_results': 200,
    });

    expect(result.movies.length, 2);
    expect(result.movies.first.title, 'First');
    expect(result.page, 1);
  });
}
