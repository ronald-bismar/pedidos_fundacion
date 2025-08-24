// lib/features/orders/domain/repositories/place_repository.dart

import '../../domain/entities/place_entity.dart';


abstract class PlaceRepository {
  Future<List<PlaceEntity>> getPlaces();
  Future<void> addPlace(PlaceEntity place);
  Future<void> updatePlace(PlaceEntity place);
  Future<void> deletePlace(String id);
  Future<void> restorePlace(PlaceEntity place);
  Future<void> blockPlace(String id);
}