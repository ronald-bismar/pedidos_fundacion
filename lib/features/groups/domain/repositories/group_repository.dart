// lib/features/groups/domain/repositories/group_repository.dart

import '../entities/group_entity.dart';
import '../entities/age_range.dart'; 

abstract class GroupRepository {
  Future<void> addGroup(GroupEntity group);
  Future<GroupEntity?> getGroup(String groupId);
  Stream<List<GroupEntity>> getGroups();
  Stream<List<GroupEntity>> getGroupsByTutorId(String tutorId);
  Future<void> updateGroup(GroupEntity group);
  Future<void> updateAgeRange(String groupId, AgeRange newAgeRange);
  Future<void> deleteGroup(String id);
  Future<void> restoreGroup(String id);
  Future<void> blockGroup(String id);
  Future<GroupEntity?> getGroupByAge(int age);
  Future<List<GroupEntity>> getGroupsByPlaceId(String placeId);
}