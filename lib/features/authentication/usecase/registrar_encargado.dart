import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';

class RegisterCoordinatorUseCase {
  final CoordinatorRepository coordinatorRepository;
  RegisterCoordinatorUseCase(this.coordinatorRepository);

  Future<Result> execute(Coordinator coordinator) async {
    try {
      // Check if the coordinator already exists by email or DNI
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
