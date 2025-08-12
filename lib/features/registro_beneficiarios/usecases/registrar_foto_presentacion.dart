import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';

final registerPhotoPresentationBeneficiaryProvider = Provider(
  (ref) => RegisterPhotoPresentationBeneficiaryUseCase(
    ref.watch(beneficiaryRepoProvider),
  ),
);

class RegisterPhotoPresentationBeneficiaryUseCase {
  final BeneficiaryRepository repository;

  RegisterPhotoPresentationBeneficiaryUseCase(this.repository);

  Future<Result> call(File? image, Beneficiary beneficiary) async {
    try {
      if (image == null) {
        return Result.failure('Failed to register photo');
      }

      if (!image.existsSync()) {
        return Result.failure('Image file does not exist');
      }

      final photo = await repository.registerPhoto(image);

      if (photo != null) {
        repository.updatePhotoBeneficiary(beneficiary, photo);
        return Result.success(photo.id);
      }

      return Result.failure('Failed to register photo');
    } catch (e) {
      return Result.failure('Error registering photo: ${e.toString()}');
    }
  }
}
