import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

// Use case para validar los datos del beneficiario DE LA PRIMERA PANTALLA DE REGISTRO

// Si se añade un nuevo campo, se debe actualizar este use case

final assignGroupUseCaseProvider = Provider((ref) => AssignGroupUseCase());

class AssignGroupUseCase {
  Beneficiary call(Beneficiary beneficiary) {
    //Aqui se le debe asignar el idGroup al beneficiario
  }
}
