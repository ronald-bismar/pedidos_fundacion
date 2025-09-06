sealed class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String data;

  const RegisterSuccess(this.data);
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);
}
