// lib/features/groups/domain/usecases/add_group_usecase.dart

import '../repositories/group_repository.dart';
import '../entities/group_entity.dart';

class AddGroupUseCase {
  final GroupRepository repository;

  AddGroupUseCase(this.repository);

  Future<void> call(GroupEntity group) => repository.addGroup(group);
}