sealed class RegisterPhotoState {
  const RegisterPhotoState();
}

class RegisterInitial extends RegisterPhotoState {}

class RegisterLoading extends RegisterPhotoState {}

class RegisterSuccess extends RegisterPhotoState {
  final String message;

  const RegisterSuccess(this.message);
}

class RegisterFailure extends RegisterPhotoState {
  final String error;

  const RegisterFailure(this.error);
}
