import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/features/beneficiarios/presentation/states/register_beneficiary_state.dart';
import 'package:pedidos_fundacion/features/beneficiarios/usecases/registrar_telefono_ubicacion.dart';

final registerPhoneLocationBeneficiaryProvider =
    StateNotifierProvider<
      RegisterBeneficiaryNotifier,
      RegisterBeneficiaryState
    >(
      (ref) => RegisterBeneficiaryNotifier(
        ref.watch(registerPhoneLocationUseCaseProvider),
      ),
    );

class RegisterBeneficiaryNotifier
    extends StateNotifier<RegisterBeneficiaryState> {
  final RegisterPhoneLocationUseCase registerPhoneLocationUseCase;

  RegisterBeneficiaryNotifier(this.registerPhoneLocationUseCase)
    : super(RegisterInitial());

  // Método para iniciar registro
  Future<void> registerPhoneLocation({
    required Beneficiary beneficiary,
    required String phone,
    required String region,
    required String address,
  }) async {
    try {
      state = RegisterLoading();

      final Result result = await registerPhoneLocationUseCase(
        beneficiary,
        phone,
        region,
        address,
      );

      if (result.isSuccess) {
        state = RegisterSuccess(result.data);
      } else {
        state = RegisterFailure(result.error ?? 'Unknown error occurred');
      }
    } catch (e) {
      state = RegisterFailure(
        'Error al registrar telefono y ubicacion del beneficiario: ${e.toString()}',
      );
    }
  }

  // Opcional: método para resetear estado a inicial
  void reset() {
    state = RegisterInitial();
  }
}
