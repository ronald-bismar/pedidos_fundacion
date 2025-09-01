// lib/features/places/domain/usecases/get_places_usecase.dart
import '../../../places/domain/repositories/place_repository.dart';
import '../../../places/domain/entities/place_entity.dart';


class GetPlacesUseCase {
  final PlaceRepository repository;
  GetPlacesUseCase(this.repository);

  Future<List<PlaceEntity>> call() async {
    return await repository.getPlaces();
  }
}