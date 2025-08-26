// lib/features/orders/data/repositories_impl/place_repository_impl.dart

import 'dart:developer';

import 'package:collection/collection.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_local_datasource.dart';
import '../datasources/place_remote_datasource.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceLocalDataSource localDataSource;
  final PlaceRemoteDataSource remoteDataSource;

  PlaceRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> addPlace(PlaceEntity place) async {
    final newPlace = place.copyWith(
      lastModifiedDate: DateTime.now(),
      isSyncedToFirebase: false,
    );
    await localDataSource.addPlace(newPlace);

    try {
      final syncedPlace = await remoteDataSource.addPlace(newPlace);
      await localDataSource.updatePlace(syncedPlace.copyWith(
        isSyncedToFirebase: true,
      ));
    } catch (e) {
      log('Error de conexión a Firebase: $e');
    }
  }

  @override
  Future<void> deletePlace(String id) async {
    final localPlace = (await localDataSource.getPlaces()).firstWhereOrNull((p) => p.id == id);
    if (localPlace == null) return;
    
    final updatedPlace = localPlace.copyWith(
      state: PlaceState.deleted,
      deletDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      isSyncedToLocal: true,
      isSyncedToFirebase: false,
    );
    await localDataSource.updatePlace(updatedPlace);
    log('Lugar eliminado localmente: ${updatedPlace.id}');

    try {
      await remoteDataSource.updatePlace(updatedPlace);
      await localDataSource.updatePlace(updatedPlace.copyWith(isSyncedToFirebase: true));
      log('Lugar eliminado y sincronizado con Firebase: ${updatedPlace.id}');
    } catch (e) {
      log('Error al sincronizar con Firebase: $e');
    }
  }

  @override
  Future<List<PlaceEntity>> getPlaces() async {
    log('Iniciando proceso de sincronización completa.');
    
    await syncPendingChanges();

    try {
      log('Descargando todos los lugares de Firebase...');
      final remotePlaces = await remoteDataSource.getPlaces();

      final localPlaces = await localDataSource.getPlaces();
      
      await _updateLocalWithRemote(localPlaces, remotePlaces);

      log('Sincronización completa. Devolviendo datos locales.');
      return await localDataSource.getPlaces();
    } catch (e) {
      log('Error de sincronización con Firebase: $e');
      return await localDataSource.getPlaces();
    }
  }

  @override
  Future<void> updatePlace(PlaceEntity place) async {
    var localPlace = place.copyWith(isSyncedToLocal: true, isSyncedToFirebase: false);
    await localDataSource.updatePlace(localPlace);

    try {
      await remoteDataSource.updatePlace(localPlace);
      var syncedPlace = localPlace.copyWith(isSyncedToFirebase: true);
      await localDataSource.updatePlace(syncedPlace);
      log('Lugar actualizado y sincronizado: ${syncedPlace.id}');
    } catch (e) {
      log('Error al guardar en Firebase, se mantendrá en estado de no sincronizado: $e');
    }
  }

  @override
  Future<void> restorePlace(String id) async {
    final localPlace = (await localDataSource.getPlaces()).firstWhereOrNull((p) => p.id == id);
    if (localPlace == null) return;

    final updatedPlace = localPlace.copyWith(
      state: PlaceState.active,
      restorationDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      deletDate: null,
      blockDate: null,
      isSyncedToLocal: true,
      isSyncedToFirebase: false,
    );
    await localDataSource.updatePlace(updatedPlace);

    try {
      await remoteDataSource.updatePlace(updatedPlace);
      await localDataSource.updatePlace(updatedPlace.copyWith(isSyncedToFirebase: true));
      log('Lugar restaurado y sincronizado: ${updatedPlace.id}');
    } catch (e) {
      log('Error al sincronizar restauración: $e');
    }
  }

  @override
  Future<void> blockPlace(String id) async {
    final localPlace = (await localDataSource.getPlaces()).firstWhereOrNull((p) => p.id == id);
    if (localPlace == null) return;

    final updatedPlace = localPlace.copyWith(
      state: PlaceState.blocked,
      blockDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      deletDate: null,
      restorationDate: null,
      isSyncedToLocal: true,
      isSyncedToFirebase: false,
    );
    await localDataSource.updatePlace(updatedPlace);
    log('Lugar bloqueado localmente: ${updatedPlace.id}');

    try {
      await remoteDataSource.updatePlace(updatedPlace);
      await localDataSource.updatePlace(updatedPlace.copyWith(isSyncedToFirebase: true));
      log('Lugar bloqueado y sincronizado con Firebase: ${updatedPlace.id}');
    } catch (e) {
      log('Error al sincronizar bloqueo: $e');
    }
  }

  Future<void> syncPendingChanges() async {
    log('Iniciando sincronización de cambios pendientes...');
    final pendingPlaces = (await localDataSource.getPlaces())
        .where((place) => !place.isSyncedToFirebase)
        .toList();

    log('Lugares pendientes de sincronizar: ${pendingPlaces.length}');

    for (var place in pendingPlaces) {
      try {
        await remoteDataSource.updatePlace(place);
        await localDataSource.updatePlace(place.copyWith(isSyncedToFirebase: true));
        log('Sincronizado con éxito: ${place.id}');
      } catch (e) {
        log('Fallo al sincronizar: ${place.id}, Error: $e');
      }
    }
  }
  
  Future<void> _updateLocalWithRemote(
    List<PlaceEntity> localPlaces,
    List<PlaceEntity> remotePlaces,
  ) async {
    final localMap = {for (var place in localPlaces) place.id: place};
    final remoteMap = {for (var place in remotePlaces) place.id: place};

    for (var remotePlace in remotePlaces) {
      if (!localMap.containsKey(remotePlace.id)) {
        await localDataSource.addPlace(remotePlace);
        log('Lugar nuevo de Firebase añadido localmente: ${remotePlace.id}');
      }
    }

    for (var localPlace in localPlaces) {
      final remotePlace = remoteMap[localPlace.id];

      if (remotePlace == null) {
        await localDataSource.deletePlace(localPlace);
        log('Lugar eliminado en Firebase, se eliminó localmente: ${localPlace.id}');
      } else {
        if (remotePlace.lastModifiedDate.isAfter(localPlace.lastModifiedDate)) {
          await localDataSource.updatePlace(remotePlace);
          log('Lugar local actualizado con cambios de Firebase: ${remotePlace.id}');
        }
      }
    }
  }
}