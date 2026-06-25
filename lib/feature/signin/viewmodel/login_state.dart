import 'package:task_electro_pi/feature/signin/data/model/auth_session_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final AuthSessionModel session;

  LoginSuccessState(this.session);
}

class LoginFailureState extends LoginStates {
  final String error;

  LoginFailureState(this.error);
}

class ObscureToggleState extends LoginStates {
  final bool isObscure;

  ObscureToggleState(this.isObscure);
}
