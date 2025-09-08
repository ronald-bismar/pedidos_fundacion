// lib/features/groups/presentation/screens/groups_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_providers.dart';
import '../widgets/group_list_item.dart';
import '../widgets/group_form_dialog.dart';
import '../widgets/confirm_delete_group_dialog.dart';
import '../widgets/empty_groups_placeholder.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_state.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsyncValue = ref.watch(groupsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Grupos'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: groupsAsyncValue.when(
        data: (groups) {
          if (groups.isEmpty) {
            return const EmptyGroupsPlaceholder();
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return GroupListItem(
                group: group,
                onEdit: () => _handleEdit(context, ref, group),
                onDelete: () => _handleDelete(context, ref, group),
                onRestore: () => _handleRestore(context, ref, group),
                onBlock: () => _handleBlock(context, ref, group),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(
          child: Text('Error: $e'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAdd(context, ref),
        child: const Icon(Icons.add, color: Colors.white),

        tooltip: 'Añadir nuevo grupo', 
         backgroundColor: Colors.blue.shade700,
      ),
   
    );
  }

  void _handleAdd(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (_) => const GroupFormDialog(),
    );

    if (result != null) {
      final notifier = ref.read(groupsNotifierProvider.notifier);
      await notifier.addGroup(
        name: result['name'],
        idTutor: result['idTutor'],
        minAge: result['minAge'],
        maxAge: result['maxAge'],
      );
    }
  }

  void _handleEdit(BuildContext context, WidgetRef ref, GroupEntity group) async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (_) => GroupFormDialog(groupToEdit: group),
    );

    if (result != null) {
      final updatedGroup = GroupEntity(
        id: group.id,
        name: result['name'],
        idTutor: result['idTutor'],
        minAge: result['minAge'],
        maxAge: result['maxAge'],
        state: group.state,
        placeIds: group.placeIds,
        registrationDate: group.registrationDate,
        lastModifiedDate: DateTime.now(),
      );
      final notifier = ref.read(groupsNotifierProvider.notifier);
      await notifier.updateGroup(updatedGroup);
    }
  }

  void _handleDelete(BuildContext context, WidgetRef ref, GroupEntity group) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteGroupDialog(groupToDelete: group),
    );

    if (confirm == true) {
      final notifier = ref.read(groupsNotifierProvider.notifier);
      await notifier.deleteGroup(group.id);
    }
  }

  void _handleRestore(BuildContext context, WidgetRef ref, GroupEntity group) async {
    final notifier = ref.read(groupsNotifierProvider.notifier);
    await notifier.restoreGroup(group.id);
  }

  void _handleBlock(BuildContext context, WidgetRef ref, GroupEntity group) async {
    final notifier = ref.read(groupsNotifierProvider.notifier);
    await notifier.blockGroup(group.id);
  }
}