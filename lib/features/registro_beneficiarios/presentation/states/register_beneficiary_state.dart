sealed class RegisterBeneficiaryState {
  const RegisterBeneficiaryState();
}

class RegisterInitial extends RegisterBeneficiaryState {}

class RegisterLoading extends RegisterBeneficiaryState {}

class RegisterSuccess extends RegisterBeneficiaryState {
  final String data;

  const RegisterSuccess(this.data);
}

class RegisterFailure extends RegisterBeneficiaryState {
  final String error;

  const RegisterFailure(this.error);
}
