// lib/features/orders/data/repositories_impl/place_repository_impl.dart

import 'dart:developer';

import 'package:collection/collection.dart'; // Importa esta librería para usar firstWhereOrNull

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
      await remoteDataSource.addPlace(newPlace);
      await localDataSource.updatePlace(newPlace.copyWith(
        isSyncedToFirebase: true,
      ));
    } catch (e) {
      print('Error de conexión a Firebase: $e');
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
    // 1. Sincronizar cambios pendientes antes de cualquier cosa
    await syncPendingChanges();

    // 2. Obtener datos locales (ahora actualizados con los cambios pendientes)
    final localPlaces = await localDataSource.getPlaces();
    log('Datos locales obtenidos: ${localPlaces.length}');

    // 3. Si no hay datos locales, busca en Firebase
    if (localPlaces.isEmpty) {
      log('No hay datos locales. Cargando desde Firebase...');
      try {
        final remotePlaces = await remoteDataSource.getPlaces();
        for (var place in remotePlaces) {
          await localDataSource.addPlace(place.copyWith(isSyncedToLocal: true, isSyncedToFirebase: true));
        }
        return remotePlaces;
      } catch (e) {
        log('Error al cargar desde Firebase: $e');
        return [];
      }
    }
    return localPlaces;
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

  // Nuevo método para sincronizar cambios pendientes
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
}