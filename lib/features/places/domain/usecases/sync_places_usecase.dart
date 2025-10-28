// lib/features/places/domain/usecases/sync_places_usecase.dart
import '../repositories/place_repository.dart';

class SyncPlacesUseCase {
  final PlaceRepository repository;
  SyncPlacesUseCase(this.repository);

  Future<void> call() async {
    await repository.syncPlaces();
  }
}