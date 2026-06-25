import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_electro_pi/core/utils/app_cache.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/core/utils/service_locator.dart';
import 'package:task_electro_pi/feature/favorites/viewmodel/favorites_cubit.dart';
import 'package:task_electro_pi/feature/signin/data/model/auth_session_model.dart';
import 'package:task_electro_pi/feature/signin/data/repository/auth_repository.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/login_state.dart';
import 'package:task_electro_pi/feature/signin/viewmodel/session_cubit.dart';

class LoginCubit extends Cubit<LoginStates> {
  final AuthRepository repository;
  final SessionCubit sessionCubit;

  LoginCubit({
    required this.repository,
    required this.sessionCubit,
  }) : super(LoginInitialState()) {
    usernameController.text =
        AppCache.getString(key: AppStrings.savedUsernameKey) ??
            AppStrings.defaultUsername;
    passwordController.text =
        AppCache.getString(key: AppStrings.savedPasswordKey) ??
            AppStrings.defaultPassword;
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    emit(ObscureToggleState(obscurePassword));
  }

  Future<void> login() async {
    emit(LoginLoadingState());

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final result = await repository.login(
      username: username,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginFailureState(failure.message)),
      (session) async {
        await saveSession(session, username, password);
        sessionCubit.setSession(session);
        await getIt<FavoritesCubit>().loadFavoritesIfNeeded();
        emit(LoginSuccessState(session));
      },
    );
  }

  Future<void> saveSession(
    AuthSessionModel session,
    String username,
    String password,
  ) async {
    await AppCache.setString(
      key: AppStrings.sessionIdKey,
      value: session.sessionId,
    );
    await AppCache.setString(
      key: AppStrings.accountIdKey,
      value: session.accountId.toString(),
    );
    await AppCache.setString(
      key: AppStrings.usernameKey,
      value: session.username,
    );
    await AppCache.setString(
      key: AppStrings.savedUsernameKey,
      value: username,
    );
    await AppCache.setString(
      key: AppStrings.savedPasswordKey,
      value: password,
    );
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
