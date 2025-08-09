import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/states/register_beneficiary_state.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/usecases/register_beneficiario_usecase.dart';

final registerBeneficiaryProvider =
    StateNotifierProvider<
      RegisterBeneficiaryNotifier,
      RegisterBeneficiaryState
    >(
      (ref) =>
          RegisterBeneficiaryNotifier(ref.watch(registerBeneficiaryUseCaseProvider)),
    );

class RegisterBeneficiaryNotifier
    extends StateNotifier<RegisterBeneficiaryState> {
  final RegisterBeneficiaryUseCase registerBeneficiary;

  RegisterBeneficiaryNotifier(this.registerBeneficiary)
    : super(RegisterInitial());

  // Método para iniciar registro
  Future<void> registerUser({required Beneficiary beneficiary}) async {
    try {
      state = RegisterLoading();

      final Result result = await registerBeneficiary(beneficiary);

      if (result.isSuccess) {
        state = RegisterSuccess(result.data);
      } else {
        state = RegisterFailure(result.error ?? 'Unknown error occurred');
      }
    } catch (e) {
      state = RegisterFailure('Error al registrar usuario: ${e.toString()}');
    }
  }

  // Opcional: método para resetear estado a inicial
  void reset() {
    state = RegisterInitial();
  }
}
