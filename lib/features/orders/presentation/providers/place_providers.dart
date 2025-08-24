// lib/features/orders/presentation/providers/place_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
import '../../data/datasources/place_local_datasource.dart';
import '../../data/datasources/place_remote_datasource.dart';
import '../../data/repositories_impl/place_repository_impl.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'Fundacion.db');
  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(PlaceLocalDataSourceImpl.places);
    },
  );
});

final placeLocalDataSourceProvider = FutureProvider<PlaceLocalDataSource>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return PlaceLocalDataSourceImpl(db);
});

final placeRemoteDataSourceProvider = Provider<PlaceRemoteDataSource>((ref) {
  return PlaceRemoteDataSource();
});

final placeRepositoryProvider = FutureProvider<PlaceRepository>((ref) async {
  final localDataSource = await ref.watch(placeLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(placeRemoteDataSourceProvider);
  return PlaceRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

final placeProvider = StateNotifierProvider<PlaceNotifier, List<PlaceEntity>>((ref) {
  final placeRepositoryAsync = ref.watch(placeRepositoryProvider);

  if (placeRepositoryAsync.isLoading || placeRepositoryAsync.hasError) {
    return PlaceNotifier(placeRepository: null);
  }

  final placeRepository = placeRepositoryAsync.value!;
  return PlaceNotifier(placeRepository: placeRepository);
});

class PlaceNotifier extends StateNotifier<List<PlaceEntity>> {
  final PlaceRepository? placeRepository;

  PlaceNotifier({required this.placeRepository}) : super([]) {
    if (placeRepository != null) {
      loadPlaces();
    }
  }

  Future<void> loadPlaces() async {
    if (placeRepository == null) {
      return;
    }
    try {
      final places = await placeRepository!.getPlaces();
      state = places;
      print('¡Lugares cargados con éxito! Total de lugares: ${state.length}');
    } catch (e) {
      print('Error cargando lugares: $e');
      state = [];
    }
  }

  Future<void> addPlace({
    required String country,
    required String department,
    required String province,
    required String city,
  }) async {
    if (placeRepository == null) return;
    
    final newPlace = PlaceEntity.newPlace(
      country: country.trim(),
      department: department.trim(),
      province: province.trim(),
      city: city.trim(),
    );

    await placeRepository!.addPlace(newPlace);
    await loadPlaces();
  }

  Future<void> updatePlace(PlaceEntity updatedPlace) async {
    if (placeRepository == null) return;
    
    final placeWithUpdatedDate = updatedPlace.copyWith(lastModifiedDate: DateTime.now());
    await placeRepository!.updatePlace(placeWithUpdatedDate);
    await loadPlaces();
  }

  Future<void> deletePlace(String id) async {
    if (placeRepository == null) return;
    await placeRepository!.deletePlace(id);
    await loadPlaces();
  }

  Future<void> restorePlace(String id) async {
    if (placeRepository == null) return;
    
    // Busca la entidad en el estado local por su ID
    final placeToRestore = state.firstWhere((place) => place.id == id);

    // Actualiza la entidad con el nuevo estado y las fechas de restauración y modificación
    final updatedPlace = placeToRestore.copyWith(
      state: PlaceState.active,
      restorationDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      deletDate: null, // Aseguramos que la fecha de eliminación sea nula
      blockDate: null, // Y la fecha de bloqueo también sea nula
    );
    
    // Pasa la entidad completa al repositorio
    await placeRepository!.restorePlace(updatedPlace);
    await loadPlaces();
  }

  Future<void> blockPlace(String id) async {
    if (placeRepository == null) return;
    
    // Busca la entidad en el estado local por su ID
    final placeToBlock = state.firstWhere((place) => place.id == id);
    
    // Actualiza la entidad con el nuevo estado y la fecha de bloqueo y modificación
    final updatedPlace = placeToBlock.copyWith(
      state: PlaceState.blocked,
      blockDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      restorationDate: null, // Aseguramos que la fecha de restauración sea nula
      deletDate: null, // Y la fecha de eliminación también sea nula
    );

    // Pasa solo el id al repositorio
    await placeRepository!.blockPlace(updatedPlace.id);
    await loadPlaces();
  }
}

final activePlacesProvider = Provider<List<PlaceEntity>>((ref) {
  final places = ref.watch(placeProvider);
  return places.where((place) => place.state == PlaceState.active).toList();
});

final deletedPlacesProvider = Provider<List<PlaceEntity>>((ref) {
  final places = ref.watch(placeProvider);
  return places.where((place) => place.state == PlaceState.deleted).toList();
});

final blockedPlacesProvider = Provider<List<PlaceEntity>>((ref) {
  final places = ref.watch(placeProvider);
  return places.where((place) => place.state == PlaceState.blocked).toList();
});