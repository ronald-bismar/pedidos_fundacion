// lib/features/orders/presentation/providers/place_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/datasources/place_local_datasource.dart';
import '../../data/datasources/place_remote_datasource.dart';
import '../../data/repositories_impl/place_repository_impl.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/repositories/place_repository.dart';
// Importacion de los casos de uso
import '../../domain/usecases/add_place_usecase.dart';
import '../../domain/usecases/block_place_usecase.dart';
import '../../domain/usecases/delete_place_usecase.dart';
import '../../domain/usecases/get_places_usecase.dart';
import '../../domain/usecases/restore_place_usecase.dart';
import '../../domain/usecases/update_place_usecase.dart';
import '../notifiers/place_notifier.dart';

// -----------------------------------------------------------
// Providers de la capa de datos
// -----------------------------------------------------------

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

// -----------------------------------------------------------
// Provider del Repositorio
// -----------------------------------------------------------

final placeRepositoryProvider = FutureProvider<PlaceRepository>((ref) async {
  final localDataSource = await ref.watch(placeLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(placeRemoteDataSourceProvider);
  return PlaceRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

// -----------------------------------------------------------
// Providers de los Casos de Uso
// -----------------------------------------------------------

final getPlacesUseCaseProvider = Provider<GetPlacesUseCase>((ref) {
  final placeRepo = ref.watch(placeRepositoryProvider).value!;
  return GetPlacesUseCase(placeRepo);
});

final addPlaceUseCaseProvider = Provider<AddPlaceUseCase>((ref) {
  final placeRepo = ref.watch(placeRepositoryProvider).value!;
  return AddPlaceUseCase(placeRepo);
});

final updatePlaceUseCaseProvider = Provider<UpdatePlaceUseCase>((ref) {
  final placeRepo = ref.watch(placeRepositoryProvider).value!;
  return UpdatePlaceUseCase(placeRepo);
});

final deletePlaceUseCaseProvider = Provider<DeletePlaceUseCase>((ref) {
  final placeRepo = ref.watch(placeRepositoryProvider).value!;
  return DeletePlaceUseCase(placeRepo);
});

final restorePlaceUseCaseProvider = Provider<RestorePlaceUseCase>((ref) {
  final placeRepo = ref.watch(placeRepositoryProvider).value!;
  return RestorePlaceUseCase(placeRepo);
});

final blockPlaceUseCaseProvider = Provider<BlockPlaceUseCase>((ref) {
  final placeRepo = ref.watch(placeRepositoryProvider).value!;
  return BlockPlaceUseCase(placeRepo);
});

// -----------------------------------------------------------
// Provider del Notifier (La capa de Presentación)
// -----------------------------------------------------------

final placeProvider = StateNotifierProvider<PlaceNotifier, List<PlaceEntity>>((ref) {
  // Manejo de estado de carga y error.
  final placeRepositoryAsync = ref.watch(placeRepositoryProvider);
  if (placeRepositoryAsync.isLoading || placeRepositoryAsync.hasError) {
    // Si el repositorio no está listo, devuelve un notifier "vacío"
    // para evitar un error de Null Safety.
    return PlaceNotifier(
      getPlacesUseCase: throw Exception('Repository not ready'),
      addPlaceUseCase: throw Exception('Repository not ready'),
      updatePlaceUseCase: throw Exception('Repository not ready'),
      deletePlaceUseCase: throw Exception('Repository not ready'),
      restorePlaceUseCase: throw Exception('Repository not ready'),
      blockPlaceUseCase: throw Exception('Repository not ready'),
    );
  }

  // Si el repositorio está listo, se inyectan los casos de uso
  return PlaceNotifier(
    getPlacesUseCase: ref.read(getPlacesUseCaseProvider),
    addPlaceUseCase: ref.read(addPlaceUseCaseProvider),
    updatePlaceUseCase: ref.read(updatePlaceUseCaseProvider),
    deletePlaceUseCase: ref.read(deletePlaceUseCaseProvider),
    restorePlaceUseCase: ref.read(restorePlaceUseCaseProvider),
    blockPlaceUseCase: ref.read(blockPlaceUseCaseProvider),
  );
});

// -----------------------------------------------------------
// Providers de la Vista (filtro de datos)
// -----------------------------------------------------------

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