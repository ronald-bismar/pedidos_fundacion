// lib/features/orders/data/repositories_impl/place_repository_impl.dart
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
    await localDataSource.addPlace(place);
    await remoteDataSource.addPlace(place); // Implementa la sincronización remota si es necesario
  }

  @override
  Future<void> deletePlace(String id) async {
    final places = await getPlaces();
    final placeToDelete = places.firstWhere((p) => p.id == id);
    final updatedPlace = placeToDelete.copyWith(
      state: PlaceState.deleted,
      deletDate: DateTime.now(),
    );
    await localDataSource.updatePlace(updatedPlace);
    await remoteDataSource.updatePlace(updatedPlace); // Implementa la sincronización remota si es necesario
  }

@override
Future<List<PlaceEntity>> getPlaces() async {
  // Primero, intenta obtener datos locales
  final localPlaces = await localDataSource.getPlaces();

  // Si no hay datos locales, busca en Firebase
  if (localPlaces.isEmpty) {
    print('No hay datos locales. Cargando desde Firebase...');
    final remotePlaces = await remoteDataSource.getPlaces();
    
    // Y guarda los datos remotos en la base de datos local
    for (var place in remotePlaces) {
      await localDataSource.addPlace(place);
    }
    return remotePlaces;
  }
  
  // Si hay datos locales, los devuelve
  return localPlaces;
}

  @override
  Future<void> updatePlace(PlaceEntity place) async {
    await localDataSource.updatePlace(place);
    await remoteDataSource.updatePlace(place); // Implementa la sincronización remota si es necesario
  }

  @override
  Future<void> restorePlace(PlaceEntity place) async {
    final updatedPlace = place.copyWith(
      state: PlaceState.active,
      restorationDate: DateTime.now(),
      deletDate: null,
      blockDate: null,
    );

    await localDataSource.updatePlace(updatedPlace);
    await remoteDataSource.updatePlace(updatedPlace); // Implementa la sincronización remota si es necesario
  }

  @override
  Future<void> blockPlace(String id) async {
    // 1. Obtiene la entidad del lugar para bloquear
    final places = await getPlaces();
    final placeToBlock = places.firstWhere((p) => p.id == id);

    // 2. Actualiza el estado de la entidad
    final updatedPlace = placeToBlock.copyWith(
      state: PlaceState.blocked,
      blockDate: DateTime.now(),
      deletDate: null,
      restorationDate: null,
    );
    
    // 3. Persiste el cambio en la fuente de datos local y remota
    await localDataSource.updatePlace(updatedPlace);
    await remoteDataSource.updatePlace(updatedPlace); // Implementa la sincronización remota si es necesario
  }
}