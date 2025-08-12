import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';
import 'package:pedidos_fundacion/features/login/usecases/validar_datos.dart';
import 'package:pedidos_fundacion/presentation/user_application_provider.dart';

final loginCoordinatorProvider = Provider(
  (ref) => LoginCoordinatorUseCase(
    ref.watch(coordinatorRepoProvider),
    ref.watch(validateDataLoginUseCaseProvider),
    ref.watch(userApplicationProvider.notifier),
  ),
);

class LoginCoordinatorUseCase {
  final CoordinatorRepository coordinatorRepository;
  final ValidateDataLoginCoordinatorUseCase validateData;
  final UserApplicationNotifier userApplicationNotifier;

  LoginCoordinatorUseCase(
    this.coordinatorRepository,
    this.validateData,
    this.userApplicationNotifier,
  );

  Future<Result> call(String username, String password) async {
    try {
      final (bool isValidFields, String? message) = validateData(
        username,
        password,
      );

      if (!isValidFields) {
        return Result.failure(message ?? 'Invalid fields');
      }

      final Coordinator? coordinator = await coordinatorRepository.login(
        username,
        password,
      );

      if (coordinator == null) {
        return Result.failure('Credentials incorrects');
      }

      userApplicationNotifier.setCoordinator(coordinator);
      return Result.success(coordinator.id);
    } catch (e) {
      return Result.failure('Failed to login coordinator: $e');
    }
  }
}
