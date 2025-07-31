import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';

// Use case para validar los datos del encargado DE LA PRIMERA PANTALLA DE REGISTRO
// Si se añade un nuevo campo, se debe actualizar este use case

final validateDataUseCaseProvider = Provider(
  (ref) => ValidateDataCoordinatorUseCase(),
);

class ValidateDataCoordinatorUseCase {
  bool call(Coordinator coordinator) {
    if (coordinator.dni.isEmpty ||
        coordinator.name.isEmpty ||
        coordinator.lastName.isEmpty ||
        coordinator.email.isEmpty ||
        coordinator.role.isEmpty ||
        coordinator.profession.isEmpty) {
      return false;
    }
    return true;
  }
}
