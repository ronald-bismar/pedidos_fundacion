// lib/features/places/presentation/providers/place_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/place_entity.dart';
import '../../presentation/providers/place_providers.dart';
import '../../domain/repositories/place_repository.dart';
import '../../data/datasources/place_local_datasource.dart';
import '../../data/datasources/place_remote_datasource.dart';
import '../../data/repositories_impl/place_repository_impl.dart';
import '../../domain/usecases/add_place_usecase.dart';
import '../../domain/usecases/get_places_usecase.dart';
import '../../domain/usecases/update_place_usecase.dart';
import '../../domain/usecases/delete_place_usecase.dart';
import '../../domain/usecases/restore_place_usecase.dart';
import '../../domain/usecases/block_place_usecase.dart';
import '../../domain/usecases/sync_places_usecase.dart';

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

final getPlacesUseCaseProvider = FutureProvider<GetPlacesUseCase>((ref) async {
  final placeRepo = await ref.watch(placeRepositoryProvider.future);
  return GetPlacesUseCase(placeRepo);
});

final addPlaceUseCaseProvider = FutureProvider<AddPlaceUseCase>((ref) async {
  final placeRepo = await ref.watch(placeRepositoryProvider.future);
  return AddPlaceUseCase(placeRepo);
});

final updatePlaceUseCaseProvider = FutureProvider<UpdatePlaceUseCase>((ref) async {
  final placeRepo = await ref.watch(placeRepositoryProvider.future);
  return UpdatePlaceUseCase(placeRepo);
});

final deletePlaceUseCaseProvider = FutureProvider<DeletePlaceUseCase>((ref) async {
  final placeRepo = await ref.watch(placeRepositoryProvider.future);
  return DeletePlaceUseCase(placeRepo);
});

final restorePlaceUseCaseProvider = FutureProvider<RestorePlaceUseCase>((ref) async {
  final placeRepo = await ref.watch(placeRepositoryProvider.future);
  return RestorePlaceUseCase(placeRepo);
});

final blockPlaceUseCaseProvider = FutureProvider<BlockPlaceUseCase>((ref) async {
  final placeRepo = await ref.watch(placeRepositoryProvider.future);
  return BlockPlaceUseCase(placeRepo);
});

final syncPlacesUseCaseProvider = FutureProvider<SyncPlacesUseCase>((ref) async {
  final placeRepo = await ref.watch(placeRepositoryProvider.future);
  return SyncPlacesUseCase(placeRepo);
});

// -----------------------------------------------------------
// Provider del Notifier (La capa de Presentación)
// -----------------------------------------------------------

class PlaceNotifier extends AsyncNotifier<List<PlaceEntity>> {


  @override
  Future<List<PlaceEntity>> build() async {
    final remoteDataSource = ref.watch(placeRemoteDataSourceProvider);
    return remoteDataSource.getPlaces();
  }

  // @override
  // Future<List<PlaceEntity>> build() async {
  //   final syncPlacesUseCase = await ref.watch(syncPlacesUseCaseProvider.future);
  //   final getPlacesUseCase = await ref.watch(getPlacesUseCaseProvider.future);

  //   await syncPlacesUseCase.call();
  //   return getPlacesUseCase.call();
  // }

  Future<void> refreshData() async {
    ref.invalidateSelf();
  }



  Future<void> addPlace({
    required String country,
    required String department,
    required String province,
    required String city,
  }) async {
    state = const AsyncValue.loading();
    try {
      final addPlaceUseCase = await ref.watch(addPlaceUseCaseProvider.future);
      await addPlaceUseCase.call(
        country: country,
        department: department,
        province: province,
        city: city,
      );
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al agregar el lugar', stack);
    }
  }

  Future<void> updatePlace(PlaceEntity updatedPlace) async {
    state = const AsyncValue.loading();
    try {
      final updatePlaceUseCase = await ref.watch(updatePlaceUseCaseProvider.future);
      await updatePlaceUseCase.call(updatedPlace);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al actualizar el lugar', stack);
    }
  }

  Future<void> deletePlace(String placeId) async {
    state = const AsyncValue.loading();
    try {
      final deletePlaceUseCase = await ref.watch(deletePlaceUseCaseProvider.future);
      await deletePlaceUseCase.call(placeId);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al eliminar el lugar', stack);
    }
  }

  Future<void> restorePlace(String placeId) async {
    state = const AsyncValue.loading();
    try {
      final restorePlaceUseCase = await ref.watch(restorePlaceUseCaseProvider.future);
      await restorePlaceUseCase.call(placeId);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al restaurar el lugar', stack);
    }
  }

  Future<void> blockPlace(String placeId) async {
    state = const AsyncValue.loading();
    try {
      final blockPlaceUseCase = await ref.watch(blockPlaceUseCaseProvider.future);
      await blockPlaceUseCase.call(placeId);
      ref.invalidateSelf();
    } catch (e, stack) {
      state = AsyncValue.error('Error al bloquear el lugar', stack);
    }
  }
}

final placeNotifierProvider = AsyncNotifierProvider<PlaceNotifier, List<PlaceEntity>>(() {
  return PlaceNotifier();
});

// -----------------------------------------------------------
// Providers de la Vista (filtro de datos)
// -----------------------------------------------------------

final activePlacesProvider = Provider<AsyncValue<List<PlaceEntity>>>((ref) {
  final placesState = ref.watch(placeNotifierProvider);
  return placesState.when(
    data: (places) => AsyncValue.data(
      places.where((place) => place.state == PlaceState.active).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});

final deletedPlacesProvider = Provider<AsyncValue<List<PlaceEntity>>>((ref) {
  final placesState = ref.watch(placeNotifierProvider);
  return placesState.when(
    data: (places) => AsyncValue.data(
      places.where((place) => place.state == PlaceState.deleted).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});

final blockedPlacesProvider = Provider<AsyncValue<List<PlaceEntity>>>((ref) {
  final placesState = ref.watch(placeNotifierProvider);
  return placesState.when(
    data: (places) => AsyncValue.data(
      places.where((place) => place.state == PlaceState.blocked).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});