// lib/features/places/domain/usecases/delete_place_usecase.dart
import '../../../places/domain/repositories/place_repository.dart';



class DeletePlaceUseCase {
  final PlaceRepository repository;

  DeletePlaceUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deletePlace(id);
  }
}