import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/data/preferences_usuario.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';

final userApplicationProvider =
    StateNotifierProvider<UserApplicationNotifier, Coordinator?>(
      (ref) => UserApplicationNotifier(
        ref.watch(preferencesUsuarioProvider),
        ref.watch(coordinatorRepoProvider),
      ),
    );

class UserApplicationNotifier extends StateNotifier<Coordinator?> {
  final PreferencesUsuario preferencesUsuario;
  final CoordinatorRepository coordinatorRepository;
  UserApplicationNotifier(this.preferencesUsuario, this.coordinatorRepository)
    : super(Coordinator());

  Future<void> getFromPreferences() async {
    state = await preferencesUsuario.getPreferencesCoordinator();
  }

  void setCoordinator(Coordinator coordinator) {
    state = coordinator;
  }

  // Método para limpiar el estado (logout)
  void clearCoordinator() {
    preferencesUsuario.clearPreferences();
    state = null;
  }

  void setActive() {
    if (state != null) {
      state = state!.copyWith(active: true);
      coordinatorRepository.updateActiveCoordinator(state!);
    }
  }
}
