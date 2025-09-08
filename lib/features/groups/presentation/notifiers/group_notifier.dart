// lib/features/groups/presentation/notifiers/group_notifier.dart

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/usecases/add_group_usecase.dart';
import '../../domain/usecases/get_groups_usecase.dart';
import '../../domain/usecases/update_group_usecase.dart';
import '../../domain/usecases/delete_group_usecase.dart';
import '../../domain/usecases/restore_group_usecase.dart';
import '../../domain/usecases/block_group_usecase.dart';
import '../providers/group_providers.dart';

// El Notifier que maneja el estado de los grupos de manera asíncrona.
class GroupsNotifier extends AsyncNotifier<List<GroupEntity>> {
  @override
  Future<List<GroupEntity>> build() async {
    log('Iniciando carga de grupos...');
    final getGroupsUseCase = ref.read(getGroupsUseCaseProvider);
    return getGroupsUseCase.call().first;
  }

  Future<void> addGroup({
    required String name,
    required String idTutor,
    required int minAge,
    required int maxAge,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newGroup = GroupEntity.newGroup(
        name: name,
        idTutor: idTutor,
        placeIds: [],
        minAge: minAge,
        maxAge: maxAge,
      );
      final addGroupUseCase = ref.read(addGroupUseCaseProvider);
      await addGroupUseCase.call(newGroup);
      return ref.read(getGroupsUseCaseProvider).call().first;
    });
  }

  Future<void> updateGroup(GroupEntity updatedGroup) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final updateGroupUseCase = ref.read(updateGroupUseCaseProvider);
      await updateGroupUseCase.call(updatedGroup);
      return ref.read(getGroupsUseCaseProvider).call().first;
    });
  }

  Future<void> deleteGroup(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final deleteGroupUseCase = ref.read(deleteGroupUseCaseProvider);
      await deleteGroupUseCase.call(id);
      return ref.read(getGroupsUseCaseProvider).call().first;
    });
  }

  Future<void> restoreGroup(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final restoreGroupUseCase = ref.read(restoreGroupUseCaseProvider);
      await restoreGroupUseCase.call(id);
      return ref.read(getGroupsUseCaseProvider).call().first;
    });
  }

  Future<void> blockGroup(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final blockGroupUseCase = ref.read(blockGroupUseCaseProvider);
      await blockGroupUseCase.call(id);
      return ref.read(getGroupsUseCaseProvider).call().first;
    });
  }
}

final groupsNotifierProvider =
    AsyncNotifierProvider<GroupsNotifier, List<GroupEntity>>(() {
  return GroupsNotifier();
});