// lib/features/groups/data/repositories_impl/group_repository_impl.dart

import 'dart:developer';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_state.dart';
import '../../domain/repositories/group_repository.dart';
import '../../domain/entities/age_range.dart';
import '../datasources/group_remote_datasource.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addGroup(GroupEntity group) async {
    try {
      log('--> REPOSITORIO: Intentando agregar grupo a Firebase: ${group.id}');

      final highestNumber = await remoteDataSource.getHighestGroupIdNumber();

      final newIdNumber = (highestNumber + 1).toString().padLeft(3, '0');
      final newId = 'group_$newIdNumber';

      final newGroup = GroupEntity(
        id: newId,
        name: group.name,
        idTutor: group.idTutor,
        placeIds: group.placeIds,
        minAge: group.minAge,
        maxAge: group.maxAge,
        state: GroupState.active,
        registrationDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      );

      await remoteDataSource.addGroup(newGroup);

      log(
        '--> REPOSITORIO: Grupo agregado exitosamente a Firebase con ID: $newId',
      );
    } catch (e) {
      log('--> REPOSITORIO: Error al agregar grupo a Firebase: $e');
    }
  }

  @override
  Future<void> updateGroup(GroupEntity group) async {
    log(
      '--> REPOSITORIO: Intentando actualizar grupo en Firebase: ${group.id}',
    );
    await remoteDataSource.updateGroup(group);
    log('--> REPOSITORIO: Grupo actualizado exitosamente en Firebase.');
  }

  @override
  Future<void> deleteGroup(String id) async {
    log('--> REPOSITORIO: Intentando eliminar grupo en Firebase con ID: $id');
    await remoteDataSource.deleteGroup(id);
    log('--> REPOSITORIO: Grupo eliminado exitosamente de Firebase.');
  }

  @override
  Future<void> restoreGroup(String id) async {
    log('--> REPOSITORIO: Intentando restaurar grupo en Firebase con ID: $id');
    await remoteDataSource.restoreGroup(id);
    log('--> REPOSITORIO: Grupo restaurado exitosamente en Firebase.');
  }

  @override
  Future<void> blockGroup(String id) async {
    log('--> REPOSITORIO: Intentando bloquear grupo en Firebase con ID: $id');
    await remoteDataSource.blockGroup(id);
    log('--> REPOSITORIO: Grupo bloqueado exitosamente en Firebase.');
  }

  @override
  Stream<List<GroupEntity>> getGroups() {
    log('--> REPOSITORIO: Obteniendo grupos directamente de Firebase.');
    return remoteDataSource.getGroups();
  }

  @override
  Future<List<GroupEntity>> getGroupsByPlaceId(String placeId) async {
    log('--> REPOSITORIO: Obteniendo grupos para el lugar con ID: $placeId');
    return await remoteDataSource.getGroupsByPlaceId(placeId).first;
  }

  @override
  Future<GroupEntity?> getGroup(String groupId) async {
    return await remoteDataSource.getGroup(groupId);
  }

  @override
  Stream<List<GroupEntity>> getGroupsByTutorId(String tutorId) {
    return remoteDataSource.getGroupsByTutorId(tutorId);
  }

  @override
  Future<void> updateAgeRange(String groupId, AgeRange newAgeRange) async {
    await remoteDataSource.updateAgeRange(groupId, newAgeRange);
  }

  @override
  Future<GroupEntity?> getGroupByAge(int age) async {
    return await remoteDataSource.getGroupByAge(age);
  }
}