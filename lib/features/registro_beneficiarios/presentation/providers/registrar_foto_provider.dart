import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/states/register_photo_state.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/usecases/registrar_foto_presentacion.dart';

final registerPhotoBeneficiaryProvider =
    StateNotifierProvider<RegisterPhotoBeneficiaryNotifier, RegisterPhotoState>(
      (ref) => RegisterPhotoBeneficiaryNotifier(
        ref.watch(registerPhotoPresentationBeneficiaryProvider),
      ),
    );

class RegisterPhotoBeneficiaryNotifier
    extends StateNotifier<RegisterPhotoState> {
  final RegisterPhotoPresentationBeneficiaryUseCase registerPhotoPresentation;

  RegisterPhotoBeneficiaryNotifier(this.registerPhotoPresentation)
    : super(RegisterInitial());

  Future<void> registerPhoto({
    required Beneficiary beneficiary,
    required File? photo,
  }) async {
    try {
      state = RegisterLoading();

      final Result result = await registerPhotoPresentation(photo, beneficiary);

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
