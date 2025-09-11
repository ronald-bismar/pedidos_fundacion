// lib/features/groups/domain/usecases/restore_group_usecase.dart

import '../repositories/group_repository.dart';

class RestoreGroupUseCase {
  final GroupRepository repository;

  RestoreGroupUseCase(this.repository);

  Future<void> call(String groupId) async {
    await repository.restoreGroup(groupId);
  }
}