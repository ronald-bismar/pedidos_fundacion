// lib/features/places/domain/usecases/block_place_usecase.dart
import '../../../places/domain/repositories/place_repository.dart';



class BlockPlaceUseCase {
  final PlaceRepository repository;

  BlockPlaceUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.blockPlace(id);
  }
}