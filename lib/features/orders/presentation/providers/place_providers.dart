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
  // Aquí usamos ref.watch para obtener el repositorio. Riverpod se encarga
  // de esperar a que placeRepositoryProvider resuelva su Future.
  final placeRepository = ref.watch(placeRepositoryProvider).value;

  // Si el repositorio aún no está disponible, no creamos el notificador.
  // Esto es un patrón válido, pero lo mejor es manejar la carga en el UI.
  if (placeRepository == null) {
    return PlaceNotifier(placeRepository: null);
  }

  return PlaceNotifier(placeRepository: placeRepository);
});

class PlaceNotifier extends StateNotifier<List<PlaceEntity>> {
  final PlaceRepository? placeRepository;

  // ¡Nuevo! Llama a loadPlaces() en el constructor.
  PlaceNotifier({required this.placeRepository}) : super([]) {
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    if (placeRepository == null) {
      print('El repositorio no está disponible para cargar los lugares.');
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
    final newPlace = PlaceEntity(
      id: const Uuid().v4(),
      country: country.trim(),
      department: department.trim(),
      province: province.trim(),
      city: city.trim(),
      state: PlaceState.active,
      registrationDate: DateTime.now(),
      deletDate: null,
      lastModifiedDate: null,
      restorationDate: null,
      blockDate: null,
    );
    await placeRepository!.addPlace(newPlace);
    await loadPlaces();
  }

  Future<void> updatePlace(PlaceEntity updatedPlace) async {
    if (placeRepository == null) return;
    await placeRepository!.updatePlace(updatedPlace);
    await loadPlaces();
  }

  Future<void> deletePlace(String id) async {
    if (placeRepository == null) return;
    await placeRepository!.deletePlace(id);
    await loadPlaces();
  }

  Future<void> restorePlace(PlaceEntity place) async {
    if (placeRepository == null) return;
    await placeRepository!.restorePlace(place);
    await loadPlaces();
  }

  Future<void> blockPlace(String id) async {
    if (placeRepository == null) return;
    await placeRepository!.blockPlace(id);
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