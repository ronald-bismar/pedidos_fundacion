import 'dart:io';

import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';

abstract class CoordinatorRepository {
  Future<String?> registerCoordinator(Coordinator coordinator);
  Future<bool> existsByEmail(String email);
  Future<bool> existsByDni(String dni);
  Stream<Coordinator?> getCoordinator(String id);
  Future<Photo?> registerPhoto(File image);
  Future<void> updatePhotoCoordinator(Coordinator coordinator, Photo photo);
  void updateLocationCoordinator(Coordinator coordinator);
  Future<Coordinator?> login(String user, String password);
  void updateActiveCoordinator(Coordinator coordinator);
  Future<({String name, String? urlPhoto, bool isLocal})?> getNameAndPhoto(
    Coordinator coordinator,
  );
  Future<List<Coordinator>> getCoordinators();
}
