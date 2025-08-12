import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/features/login/presentation/states/login_state.dart';
import 'package:pedidos_fundacion/features/login/usecases/login_encargado.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.watch(loginCoordinatorProvider)),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginCoordinatorUseCase loginCoordinatorUseCase;

  LoginNotifier(this.loginCoordinatorUseCase) : super(LoginInitial());

  // Método para iniciar el login
  Future<void> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      state = LoginLoading();

      final Result result = await loginCoordinatorUseCase(username, password);

      if (result.isSuccess) {
        state = LoginSuccess(result.data);
      } else {
        state = LoginFailure(result.error ?? 'Unknown error occurred');
      }
    } catch (e) {
      state = LoginFailure('Error al ingresar: ${e.toString()}');
    }
  }

  // Opcional: método para resetear estado a inicial
  void reset() {
    state = LoginInitial();
  }
}
