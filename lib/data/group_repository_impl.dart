import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/data/datasources/grupo/local_datasources.dart';
import 'package:pedidos_fundacion/data/datasources/grupo/remote_datasources.dart';
import 'package:pedidos_fundacion/domain/entities/programa.dart';
import 'package:pedidos_fundacion/domain/entities/rango_edad.dart';
import 'package:pedidos_fundacion/domain/repositories/group_repository.dart';

final groupRepoProvider = Provider(
  (ref) => GroupRepositoryImpl(
    ref.watch(groupLocalDataSourceProvider),
    ref.watch(groupRemoteDataSourceProvider),
  ),
);

class GroupRepositoryImpl extends GroupRepository {
  final GroupLocalDataSource localDataSource;
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<bool> createGroup(Group group) async {
    try {
      await localDataSource.insert(group);
      remoteDataSource.createGroup(group);
      return true;
    } catch (e) {
      log('Error creating group: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteGroup(String groupId) async {
    try {
      await localDataSource.delete(groupId);
      remoteDataSource.deleteGroup(groupId);
      return true;
    } catch (e) {
      log('Error deleting group: $e');
      return false;
    }
  }

  @override
  Future<List<Group>> getAllGroups() async {
    try {
      final localGroups = await localDataSource.getAllGroups();
      if (localGroups.isNotEmpty) {
        return localGroups;
      }

      final remoteGroups = await remoteDataSource.getAllGroups();

      if (remoteGroups.isNotEmpty) {
        localDataSource.insertOrUpdate(remoteGroups);
      }

      return remoteGroups;
    } catch (e) {
      log('Error getting all groups: $e');
      return [];
    }
  }

  @override
  Future<Group?> getGroupByAge(int age) async {
    try {
      final group = await localDataSource.getGroupByAge(age);
      if (group != null) {
        return group;
      }

      final groupRemote = await remoteDataSource.getFirstGroupByAge(age);

      if (groupRemote != null) {
        localDataSource.insert(groupRemote);
      }

      return groupRemote;
    } catch (e) {
      log('Error getting group ny age: $e');
    }
    return null;
  }

  @override
  Future<Group?> getGroup(String groupId) async {
    try {
      final group = await localDataSource.getGroup(groupId);
      if (group != null) {
        return group;
      }

      final groupRemote = await remoteDataSource.getGroup(groupId);

      if (groupRemote != null) {
        localDataSource.insert(groupRemote);
      }

      return groupRemote;
    } catch (e) {
      log('Error getting group ny age: $e');
    }
    return null;
  }

  @override
  Future<List<Group>> getGroupsByTutorId(String tutorId) async {
    try {
      final localGroups = await localDataSource.getGroupsByTutorId(tutorId);

      if (localGroups.isNotEmpty) {
        return localGroups;
      }

      final remoteGroups = await remoteDataSource.getGroupsByTutorId(tutorId);

      if (remoteGroups.isNotEmpty) {
        localDataSource.insertOrUpdate(remoteGroups);
      }

      return remoteGroups;
    } catch (e) {
      log('Error getting all groups: $e');
      return [];
    }
  }

  @override
  Future<bool> updateAgeRange(String groupId, AgeRange newAgeRange) async {
    try {
      await localDataSource.updateRangeOfGroup(
        groupId,
        newAgeRange.minAge,
        newAgeRange.maxAge,
      );

      remoteDataSource.updateAgeRange(groupId, newAgeRange);
      return true;
    } catch (e) {
      log('Error updating AgeRange: $e');
      return false;
    }
  }

  @override
  Future<bool> updateGroup(Group group) async {
    try {
      await localDataSource.update(group);

      remoteDataSource.updateGroup(group);
      return true;
    } catch (e) {
      log('Error updating AgeRange: $e');
      return false;
    }
  }
}
