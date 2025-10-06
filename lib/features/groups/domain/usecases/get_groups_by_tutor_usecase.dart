// lib/features/groups/domain/usecases/get_groups_by_tutor_usecase.dart

import '../repositories/group_repository.dart';
import '../entities/group_entity.dart';

class GetGroupsByTutorUseCase {
  final GroupRepository _groupRepository;

  GetGroupsByTutorUseCase(this._groupRepository);

  Stream<List<GroupEntity>> call(String tutorId) {
    return _groupRepository.getGroupsByTutorId(tutorId);
  }
}