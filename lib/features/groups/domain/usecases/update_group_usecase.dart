// lib/features/groups/domain/usecases/update_group_usecase.dart

import '../repositories/group_repository.dart';
import '../entities/group_entity.dart';

class UpdateGroupUseCase {
  final GroupRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<void> call(GroupEntity updatedGroup) async {
    await repository.updateGroup(updatedGroup);
  }
}