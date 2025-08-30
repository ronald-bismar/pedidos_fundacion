// lib/features/places/domain/usecases/add_place_usecase.dart
import '../../../places/domain/repositories/place_repository.dart';
import '../../../places/domain/entities/place_entity.dart';


class AddPlaceUseCase {
  final PlaceRepository repository;
  AddPlaceUseCase(this.repository);

  Future<void> call({
    required String country,
    required String department,
    required String province,
    required String city,
  }) async {
    final newPlace = PlaceEntity.newPlace(
      country: country.trim(),
      department: department.trim(),
      province: province.trim(),
      city: city.trim(),
    );
    print('UseCase: creando lugar con id ${newPlace.id} y ciudad ${newPlace.city}');
    await repository.addPlace(newPlace);
  }
}
