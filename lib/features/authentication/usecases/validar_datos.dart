import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';

// Use case para validar los datos del encargado DE LA PRIMERA PANTALLA DE REGISTRO

// Si se añade un nuevo campo, se debe actualizar este use case

final validateDataUseCaseProvider = Provider(
  (ref) => ValidateDataCoordinatorUseCase(),
);

class ValidateDataCoordinatorUseCase {
  //Records (Dart 3.0+)
  (bool isValid, String? message) call(Coordinator coordinator) {
    if (coordinator.dni.trim().isEmpty) {
      return (false, 'Por favor ingresa tu cédula de identidad');
    }
    if (coordinator.name.trim().isEmpty) {
      return (false, 'Por favor ingresa tu nombre');
    }
    if (coordinator.lastName.trim().isEmpty) {
      return (false, 'Por favor ingresa tus apellidos');
    }
    if (!isValidEmail(coordinator.email.trim())) {
      return (false, 'Por favor ingresa un email válido');
    }
    if (coordinator.role.trim().isEmpty) {
      return (false, 'Por favor selecciona un cargo');
    }
    if (coordinator.profession.trim().isEmpty) {
      return (false, 'Por favor ingresa tu profesión');
    }
    return (true, null);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
