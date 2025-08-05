sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String data;

  const LoginSuccess(this.data);
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);
}
