// lib/features/groups/domain/usecases/get_groups_by_place_usecase.dart

import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

class GetGroupsByPlaceUseCase {
  final GroupRepository repository;

  GetGroupsByPlaceUseCase(this.repository);

  // ✅ CORREGIDO: El nombre del método ahora coincide con el repositorio
  Future<List<GroupEntity>> call({required String placeId}) async {
    return await repository.getGroupsByPlaceId(placeId);
  }
}