// lib/features/orders/data/repositories_impl/place_repository_impl.dart

import 'dart:developer';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_local_datasource.dart';
import '../datasources/place_remote_datasource.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceRemoteDataSource remoteDataSource;
  final PlaceLocalDataSource? localDataSource;

  PlaceRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<void> addPlace(PlaceEntity place) async {
    log('--> REPOSITORIO: Intentando agregar lugar a Firebase: ${place.id}');
    await remoteDataSource.addPlace(place);
    log('--> REPOSITORIO: Lugar agregado exitosamente a Firebase.');
  }

  @override
  Future<void> updatePlace(PlaceEntity place) async {
    log('--> REPOSITORIO: Intentando actualizar lugar en Firebase: ${place.id}');
    await remoteDataSource.updatePlace(place);
    log('--> REPOSITORIO: Lugar actualizado exitosamente en Firebase.');
  }

  @override
  Future<void> deletePlace(String id) async {
    log('--> REPOSITORIO: Intentando eliminar lugar en Firebase con ID: $id');
    await remoteDataSource.deletePlace(id);
    log('--> REPOSITORIO: Lugar eliminado exitosamente de Firebase.');
  }

  @override
  Future<void> restorePlace(String id) async {
    log('--> REPOSITORIO: Intentando restaurar lugar en Firebase con ID: $id');
    await remoteDataSource.restorePlace(id);
    log('--> REPOSITORIO: Lugar restaurado exitosamente en Firebase.');
  }

  @override
  Future<void> blockPlace(String id) async {
    log('--> REPOSITORIO: Intentando bloquear lugar en Firebase con ID: $id');
    await remoteDataSource.blockPlace(id);
    log('--> REPOSITORIO: Lugar bloqueado exitosamente en Firebase.');
  }

  @override
  Future<List<PlaceEntity>> getPlaces() async {
    log('--> REPOSITORIO: Obteniendo lugares directamente de Firebase.');
    return remoteDataSource.getPlaces();
  }

  @override
  Future<void> syncPlaces() async {
    log('--> REPOSITORIO: La sincronización completa no es necesaria para la operación solo en Firebase.');
  }
}