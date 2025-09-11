// lib/features/groups/domain/usecases/get_groups_usecase.dart

import '../repositories/group_repository.dart';
import '../entities/group_entity.dart';

class GetGroupsUseCase {
  final GroupRepository repository;
  
  GetGroupsUseCase(this.repository);
  
  Stream<List<GroupEntity>> call() => repository.getGroups();
}