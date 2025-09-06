import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';
import 'package:pedidos_fundacion/features/entregas/data/entrega_repository_impl.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/producto_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/domain/repositories/entrega_repository.dart';
import 'package:pedidos_fundacion/toDataDynamic/estados_entrega.dart';

final registerDeliveryToBeneficiaryUseCaseProvider = Provider(
  (ref) => RegisterDeliveryBeneficiary(
    entregaRepository: ref.watch(entregaRepoProvider),
  ),
);

class RegisterDeliveryBeneficiary {
  EntregaRepository entregaRepository;
  RegisterDeliveryBeneficiary({required this.entregaRepository});

  Future<Result> call(
    DeliveryBeneficiary deliveryBeneficiary,
    File? photoDelivery,
    List<ProductBeneficiary> productsDeliveried,
  ) async {
    try {
      if (photoDelivery == null) {
        return Result.failure('La foto de la entrega es obligatoria');
      }

      Photo? savedPhoto = await entregaRepository.savePhotoDelivery(
        photoDelivery,
        '${deliveryBeneficiary.nameBeneficiary}_${deliveryBeneficiary.deliveryDate?.toIso8601String()}',
      );

      if (savedPhoto == null) {
        return Result.failure('Error al guardar la foto de la entrega');
      }

      deliveryBeneficiary = deliveryBeneficiary.copyWith(
        state: DeliveryStates.DELIVERED,
        deliveryDate: DateTime.now(),
        idPhotoDelivery: savedPhoto.id,
        updatedAt: DateTime.now(),
      );

      entregaRepository.saveProductsBeneficiary(productsDeliveried);

      return await entregaRepository.saveDeliveryBeneficiary(
        deliveryBeneficiary,
      );
    } catch (e) {
      return Result.failure(
        'Error al registrar la entrega del beneficiario: $e',
      );
    }
  }
}
