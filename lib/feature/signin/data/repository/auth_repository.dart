import 'package:dartz/dartz.dart';
import 'package:task_electro_pi/core/errors/failure.dart';
import 'package:task_electro_pi/feature/signin/data/model/auth_session_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionModel>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, void>> logout({required String sessionId});
}
