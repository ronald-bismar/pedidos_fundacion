// lib/features/places/domain/usecases/update_place_usecase.dart
import '../../../places/domain/repositories/place_repository.dart';
import '../../../places/domain/entities/place_entity.dart';

class UpdatePlaceUseCase {
  final PlaceRepository repository;
  UpdatePlaceUseCase(this.repository);

  Future<void> call(PlaceEntity updatedPlace) async {
    await repository.updatePlace(updatedPlace);
  }
}