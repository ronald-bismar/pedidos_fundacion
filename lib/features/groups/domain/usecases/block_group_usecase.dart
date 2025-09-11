// lib/features/groups/domain/usecases/block_group_usecase.dart

import '../repositories/group_repository.dart';

class BlockGroupUseCase {
  final GroupRepository repository;

  BlockGroupUseCase(this.repository);

  Future<void> call(String groupId) async {
    await repository.blockGroup(groupId);
  }
}