import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

// Use case para validar los datos del beneficiario DE LA PRIMERA PANTALLA DE REGISTRO

// Si se añade un nuevo campo, se debe actualizar este use case

final validateDataBeneficiaryUseCaseProvider = Provider(
  (ref) => ValidateDataBeneficiaryUseCase(),
);

class ValidateDataBeneficiaryUseCase {
  //Records (Dart 3.0+)
  (bool isValid, String? message) call(Beneficiary beneficiary) {
    if (!validateDni(beneficiary.dni.trim())) {
      return (false, 'La cedula de identidad no es válida');
    }

    if (beneficiary.name.trim().isEmpty) {
      return (false, 'Por favor ingresa el nombre del beneficiario');
    }

    if (beneficiary.lastName.trim().isEmpty) {
      return (false, 'Por favor ingresa el apellido del beneficiario');
    }

    final birthdateValidation = validateBirthdate(beneficiary.birthdate);
    if (!birthdateValidation.$1) {
      return (false, birthdateValidation.$2);
    }

    if (beneficiary.socialReasson.trim().isEmpty) {
      return (false, 'Por favor ingresa la razón social del beneficiario');
    }
    return (true, null);
  }

  bool validateDni(String dni) {
    final cleanedDni = dni.trim();

    return cleanedDni.length >= 6 &&
        RegExp(r'^[a-zA-Z0-9]+$').hasMatch(cleanedDni) &&
        RegExp(r'\d').hasMatch(cleanedDni);
  }

  // Nueva validación para fecha de nacimiento
  (bool, String?) validateBirthdate(DateTime birthdate) {
    final now = DateTime.now();

    // 1. No puede ser fecha futura
    if (birthdate.isAfter(now)) {
      return (false, 'La fecha de nacimiento no puede ser en el futuro');
    }

    final age = _calculateAge(birthdate, now);

    // 3. Edad máxima razonable (ej: 120 años)
    if (age > 120) {
      return (false, 'La fecha de nacimiento no puede ser anterior a 120 años');
    }

    // 4. Fecha no muy antigua (ej: no antes de 1900)
    if (birthdate.year < 1900) {
      return (false, 'La fecha de nacimiento debe ser posterior a 1900');
    }

    return (true, null);
  }

  // Método auxiliar para calcular edad exacta
  int _calculateAge(DateTime birthdate, DateTime currentDate) {
    int age = currentDate.year - birthdate.year;

    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month &&
            currentDate.day < birthdate.day)) {
      age--;
    }

    return age;
  }
}
