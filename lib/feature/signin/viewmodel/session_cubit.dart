import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/app_cache.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/signin/data/model/auth_session_model.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionState.initial());

  void loadSession() {
    final sessionId = AppCache.getString(key: AppStrings.sessionIdKey);
    if (sessionId == null || sessionId.isEmpty) {
      return;
    }

    final username = AppCache.getString(key: AppStrings.usernameKey);
    final accountIdRaw = AppCache.getString(key: AppStrings.accountIdKey);
    final accountId = accountIdRaw != null ? int.tryParse(accountIdRaw) : null;

    emit(
      state.copyWith(
        isAuthenticated: true,
        sessionId: sessionId,
        username: username,
        accountId: accountId,
      ),
    );
  }

  void setSession(AuthSessionModel session) {
    emit(
      state.copyWith(
        isAuthenticated: true,
        sessionId: session.sessionId,
        accountId: session.accountId,
        username: session.username,
      ),
    );
  }

  void clearSession() {
    emit(SessionState.initial());
  }
}
