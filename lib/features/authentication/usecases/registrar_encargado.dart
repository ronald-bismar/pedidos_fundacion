import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/core/utils/network_utils.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';
import 'package:pedidos_fundacion/features/authentication/usecases/generar_usuario_contrase%C3%B1a.dart';
import 'package:pedidos_fundacion/features/authentication/usecases/validar_datos.dart';

final registerCoordinatorProvider = Provider(
  (ref) => RegisterCoordinatorUseCase(
    ref.watch(coordinatorRepoProvider),
    ref.watch(validateDataUseCaseProvider),
    ref.watch(generateUserPasswordUseCaseProvider),
  ),
);

class RegisterCoordinatorUseCase {
  final CoordinatorRepository coordinatorRepository;
  final ValidateDataCoordinatorUseCase validateDataUseCase;
  final GenerateUserPasswordUseCase generateUserPasswordUseCase;

  RegisterCoordinatorUseCase(
    this.coordinatorRepository,
    this.validateDataUseCase,
    this.generateUserPasswordUseCase,
  );

  Future<Result> call(Coordinator coordinator) async {
    try {
      final (bool isValidFields, String? message) = validateDataUseCase(
        coordinator,
      );

      if (!isValidFields) {
        return Result.failure(message ?? 'Invalid fields');
      }

      final hasInternet = await NetworkUtils.hasRealInternet();
      if (!hasInternet) {
        return Result.failure('You need an internet connection to register');
      }

      final dniExists = await coordinatorRepository.existsByDni(
        coordinator.dni,
      );
      if (dniExists) {
        return Result.failure('DNI already exists');
      }

      final emailExists = await coordinatorRepository.existsByEmail(
        coordinator.email,
      );
      if (emailExists) {
        return Result.failure('Email already exists');
      }

      final coordinatorWithPassword = generateUserPasswordUseCase(coordinator);
      // Save the new coordinator
      await coordinatorRepository.saveCoordinator(coordinatorWithPassword);
      return Result.success('Coordinator registered successfully');
    } catch (e) {
      return Result.failure('Failed to register coordinator: $e');
    }
  }
}
