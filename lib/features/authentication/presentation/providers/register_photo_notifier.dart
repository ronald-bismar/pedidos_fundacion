import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/states/register_photo_state.dart';
import 'package:pedidos_fundacion/features/authentication/usecases/registrar_foto_presentacion.dart';

final registerPhotoProvider =
    StateNotifierProvider<RegisterNotifier, RegisterPhotoState>(
      (ref) => RegisterNotifier(ref.watch(registerPhotoPresentationProvider)),
    );

class RegisterNotifier extends StateNotifier<RegisterPhotoState> {
  final RegisterPhotoPresentationUseCase registerPhotoPresentation;

  RegisterNotifier(this.registerPhotoPresentation) : super(RegisterInitial());

  // Método para iniciar registro
  Future<void> registerPhoto({
    required Coordinator coordinator,
    required File? photo,
  }) async {
    try {
      state = RegisterLoading();

      final Result result = await registerPhotoPresentation(photo, coordinator);

      if (result.isSuccess) {
        state = RegisterSuccess(result.data ?? 'Registration Photo successful');
      } else {
        state = RegisterFailure(result.error ?? 'Unknown error occurred');
      }
    } catch (e) {
      state = RegisterFailure('Error while registering photo: ${e.toString()}');
    }
  }

  // Opcional: método para resetear estado a inicial
  void reset() {
    state = RegisterInitial();
  }
}
