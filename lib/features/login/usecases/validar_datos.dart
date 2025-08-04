import 'package:flutter_riverpod/flutter_riverpod.dart';

// Use case para validar los datos del encargado DE LA PRIMERA PANTALLA DE LOGIN

// Si se añade un nuevo campo, se debe actualizar este use case

final validateDataLoginUseCaseProvider = Provider(
  (ref) => ValidateDataLoginCoordinatorUseCase(),
);

class ValidateDataLoginCoordinatorUseCase {
  //Records (Dart 3.0+)
  (bool isValid, String? message) call(String username, String password) {
    if (username.trim().isEmpty) {
      return (false, 'Por favor ingresa tu usuario');
    }
    if (password.trim().isEmpty) {
      return (false, 'Por favor ingresa tus contraseña');
    }
    return (true, null);
  }
}
