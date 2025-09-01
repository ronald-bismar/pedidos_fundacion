// lib/features/orders/presentation/providers/group_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/group_entity.dart'; // Asegúrate de que la ruta es correcta

final groupProvider = StateNotifierProvider<GroupNotifier, List<GroupEntity>>((ref) {
  return GroupNotifier();
});

class GroupNotifier extends StateNotifier<List<GroupEntity>> {
  GroupNotifier() : super([]);

  void addGroup(String nombreGrupo, String ageRange) {
    final normalizedName = nombreGrupo.trim().toLowerCase();
    if (!state.any((group) => group.nombreGrupo.trim().toLowerCase() == normalizedName)) {
      final newGroup = GroupEntity(
        idCluster: const Uuid().v4(),
        nombreGrupo: nombreGrupo.trim(),
        ageRange: ageRange,
        registrationDate: DateTime.now(),
      );
      state = [...state, newGroup];
    }
  }

  void updateGroup(GroupEntity updatedGroup) {
    state = [
      for (final group in state)
        if (group.idCluster == updatedGroup.idCluster)
          updatedGroup.copyWith(editedDate: DateTime.now())
        else
          group,
    ];
  }

  void deleteGroup(String idCluster) {
    state = [
      for (final group in state)
        if (group.idCluster == idCluster)
          group.copyWith(state: GroupState.deleted, deleteDate: DateTime.now())
        else
          group,
    ];
  }

  void blockGroup(String idCluster) {
    state = [
      for (final group in state)
        if (group.idCluster == idCluster)
          group.copyWith(state: GroupState.blocked)
        else
          group,
    ];
  }

  void unblockGroup(String idCluster) {
    state = [
      for (final group in state)
        if (group.idCluster == idCluster)
          group.copyWith(state: GroupState.active, restorationDate: DateTime.now())
        else
          group,
    ];
  }

  List<GroupEntity> get activeGroups => state.where((group) => group.state == GroupState.active).toList();
  List<GroupEntity> get deletedGroups => state.where((group) => group.state == GroupState.deleted).toList();
  List<GroupEntity> get blockedGroups => state.where((group) => group.state == GroupState.blocked).toList();
}