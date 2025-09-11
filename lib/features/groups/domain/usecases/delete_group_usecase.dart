// lib/features/groups/domain/usecases/delete_group_usecase.dart

import '../repositories/group_repository.dart';

class DeleteGroupUseCase {
  final GroupRepository repository;

  DeleteGroupUseCase(this.repository);

  Future<void> call(String groupId) async {
    await repository.deleteGroup(groupId);
  }
}