import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/app_cache.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_cubit.dart';
import 'package:task_electro_pi/feature/logout/viewmodel/logout_state.dart';
import 'package:task_electro_pi/feature/signin/data/repository/auth_repository.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_cubit.dart';

class LogoutCubit extends Cubit<LogoutStates> {
  final AuthRepository authRepository;
  final SessionCubit sessionCubit;
  final FavoritesCubit favoritesCubit;

  LogoutCubit({
    required this.authRepository,
    required this.sessionCubit,
    required this.favoritesCubit,
  }) : super(LogoutInitialState());

  Future<void> logout() async {
    emit(LogoutLoadingState());

    final sessionId = sessionCubit.state.sessionId;
    if (sessionId != null && sessionId.isNotEmpty) {
      await authRepository.logout(sessionId: sessionId);
    }

    await clearLocalAuth();
    emit(LogoutSuccessState());
  }

  Future<void> clearLocalAuth() async {
    await AppCache.remove(key: AppStrings.sessionIdKey);
    await AppCache.remove(key: AppStrings.accountIdKey);
    await AppCache.remove(key: AppStrings.usernameKey);
    sessionCubit.clearSession();
    favoritesCubit.reset();
  }
}
