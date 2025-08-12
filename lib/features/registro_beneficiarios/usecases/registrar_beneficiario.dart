import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/core/utils/network_utils.dart';
import 'package:pedidos_fundacion/data/beneficiary_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';
import 'package:pedidos_fundacion/domain/repositories/beneficiary_repository.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/usecases/asignar_grupo.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/usecases/validar_datos.dart';

final registerBeneficiaryUseCaseProvider = Provider(
  (ref) => RegisterBeneficiaryUseCase(
    ref.watch(beneficiaryRepoProvider),
    ref.watch(validateDataBeneficiaryUseCaseProvider),
    ref.watch(assignGroupUseCaseProvider),
  ),
);

class RegisterBeneficiaryUseCase {
  final BeneficiaryRepository beneficiaryRepository;
  final ValidateDataBeneficiaryUseCase validateDataUseCase;
  final AssignGroupUseCase assignGroupUseCase;

  RegisterBeneficiaryUseCase(
    this.beneficiaryRepository,
    this.validateDataUseCase,
    this.assignGroupUseCase,
  );

  Future<Result> call(Beneficiary beneficiary) async {
    try {
      final hasInternet = await NetworkUtils.hasRealInternet();
      if (!hasInternet) {
        return Result.failure(
          'You need an internet connection to register beneficiary',
        );
      }

      final (bool isValidFields, String? message) = validateDataUseCase(
        beneficiary,
      );

      if (!isValidFields) {
        return Result.failure(message ?? 'Invalid fields');
      }

      final dniExists = await beneficiaryRepository.existsByDni(
        beneficiary.dni,
      );
      if (dniExists) {
        return Result.failure('DNI already exists');
      }

      final beneficiaryWithGroup = await assignGroupUseCase(beneficiary);

      // Save the new beneficiary
      final String? beneficiaryId = await beneficiaryRepository
          .registerBeneficiary(beneficiaryWithGroup);

      if (beneficiaryId == null || beneficiaryId.isEmpty) {
        return Result.failure('Failed to register beneficiary');
      }
      return Result.success(beneficiaryId);
    } catch (e) {
      return Result.failure('Failed to register beneficiary: $e');
    }
  }
}
