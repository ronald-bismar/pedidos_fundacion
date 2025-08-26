// lib/features/places/domain/usecases/restore_place_usecase.dart
import '../../../places/domain/repositories/place_repository.dart';



class RestorePlaceUseCase {
  final PlaceRepository repository;

  RestorePlaceUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.restorePlace(id);
  }
}