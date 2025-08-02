import 'dart:io';

import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/entities/foto.dart';

abstract class CoordinatorRepository {
  Future<void> saveCoordinator(Coordinator coordinator);
  Future<bool> existsByEmail(String email);
  Future<bool> existsByDni(String dni);
  Future<Coordinator?> getCoordinator(String id);
  Future<Photo?> registerPhoto(File image);
  Future<void> updatePhotoCoordinator(Coordinator coordinator, Photo photo);
}
