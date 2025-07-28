import 'package:pedidos_fundacion/domain/entities/encargado.dart';

abstract class CoordinatorRepository {
  Future<void> saveCoordinator(Coordinator coordinator);
  Future<bool> existsByEmail(String email);
  Future<bool> existsByDni(String dni);
  Future<Coordinator?> getCoordinator(String id);
}
