import 'package:task_electro_pi/feature/movies/data/model/cast_member_model.dart';

enum MovieDetailsStatus { initial, loading, success, failure }

class MovieDetailsState {
  final MovieDetailsStatus status;
  final List<CastMemberModel> cast;
  final String? trailerKey;
  final String? errorMessage;

  const MovieDetailsState({
    required this.status,
    required this.cast,
    this.trailerKey,
    this.errorMessage,
  });

  factory MovieDetailsState.initial() => const MovieDetailsState(
        status: MovieDetailsStatus.initial,
        cast: <CastMemberModel>[],
      );

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    List<CastMemberModel>? cast,
    String? trailerKey,
    String? errorMessage,
    bool clearTrailerKey = false,
    bool clearErrorMessage = false,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      cast: cast ?? this.cast,
      trailerKey: clearTrailerKey ? null : (trailerKey ?? this.trailerKey),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
