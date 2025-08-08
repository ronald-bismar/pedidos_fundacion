import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';


final generateUserPasswordUseCaseProvider = Provider(
  (ref) => GenerateUserPasswordUseCase(),
);

class GenerateUserPasswordUseCase {
  Coordinator call(Coordinator coordinator) {
    final List<String> firstCharsName = coordinator.name
        .split(' ')
        .map((word) => word[0])
        .toList();
    final List<String> firstCharsLastName = coordinator.lastName
        .split(' ')
        .map((word) => word[0])
        .toList();
    final String firstCharsWithDni =
        (firstCharsName + firstCharsLastName).join().toUpperCase() +
        coordinator.dni;

    final String password = coordinator.dni;

    return coordinator.copyWith(
      username: firstCharsWithDni,
      password: password,
    );
  }
}
