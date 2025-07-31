import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/core/utils/network_utils.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';
import 'package:pedidos_fundacion/features/authentication/usecase/validar_datos_use_case.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerCoordinatorProvider = Provider(
  (ref) => RegisterCoordinatorUseCase(
    ref.watch(coordinatorRepoProvider),
    ref.watch(validateDataUseCaseProvider),
  ),
);

class RegisterCoordinatorUseCase {
  final CoordinatorRepository coordinatorRepository;
  final ValidateDataCoordinatorUseCase validateDataUseCase;

  RegisterCoordinatorUseCase(
    this.coordinatorRepository,
    this.validateDataUseCase,
  );

  Future<Result> call(Coordinator coordinator) async {
    try {
      if (!validateDataUseCase(coordinator)) {
        return Result.failure('Please complete all fields correctly');
      }

      final hasInternet = await NetworkUtils.hasRealInternet();
      if (!hasInternet) {
        return Result.failure('No internet connection');
      }

      // Check if the coordinator already exists by email
      final emailExists = await coordinatorRepository.existsByEmail(
        coordinator.email,
      );
      if (emailExists) {
        return Result.failure('Email already exists');
      }

      // Check if the coordinator already exists by DNI
      final dniExists = await coordinatorRepository.existsByDni(
        coordinator.dni,
      );
      if (dniExists) {
        return Result.failure('DNI already exists');
      }

      // Save the new coordinator
      await coordinatorRepository.saveCoordinator(coordinator);
      return Result.success('Coordinator registered successfully');
    } catch (e) {
      return Result.failure('Failed to register coordinator: $e');
    }
  }
}
