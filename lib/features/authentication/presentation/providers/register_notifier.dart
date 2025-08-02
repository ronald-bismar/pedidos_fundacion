import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/register_state.dart';
import 'package:pedidos_fundacion/features/authentication/usecases/registrar_encargado.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(ref.watch(registerCoordinatorProvider)),
);

class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterCoordinatorUseCase registerCoordinator;

  RegisterNotifier(this.registerCoordinator) : super(RegisterInitial());

  // Método para iniciar registro
  Future<void> registerUser({required Coordinator coordinator}) async {
    try {
      state = RegisterLoading();

      final Result result = await registerCoordinator(coordinator);

      if (result.isSuccess) {
        state = RegisterSuccess(result.data ?? 'Registration successful');
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
