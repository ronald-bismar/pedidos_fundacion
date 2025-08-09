import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';

final registerPhoneLocationUseCaseProvider = Provider(
  (ref) => RegisterPhoneLocationUseCase(ref.watch(beneficiaryRepoProvider)),
);

class RegisterPhoneLocationUseCase {
  final BeneficiaryRepository beneficiaryRepository;

  RegisterPhoneLocationUseCase(this.beneficiaryRepository);

  Future<Result> call(Beneficiary beneficiary) async {
    try {
      final (bool isValidFields, String? message) = _validateLocation(
        beneficiary,
      );

      if (!isValidFields) {
        return Result.failure(message ?? 'Invalid fields');
      }

      final bool success = await beneficiaryRepository.updateLocationAndPhone(
        beneficiary,
      );

      if (success) {
        return Result.success(message ?? 'Beneficiary registered successful');
      } else {
        return Result.failure(message ?? 'Failed to register the beneficiary');
      }
    } catch (e) {
      return Result.failure('Failed to register beneficiary: $e');
    }
  }

  (bool, String?) _validateLocation(Beneficiary beneficiary) {
    if (beneficiary.location.trim().isEmpty) {
      return (false, 'Por favor ingresa el apellido del beneficiario');
    }

    return (true, null);
  }
}
