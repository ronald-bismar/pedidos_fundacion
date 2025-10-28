// lib/features/groups/presentation/widgets/group_list_item.dart

import 'package:flutter/material.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/entities/group_state.dart';

class GroupListItem extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final VoidCallback? onBlock;

  const GroupListItem({
    super.key,
    required this.group,
    this.onEdit,
    this.onDelete,
    this.onRestore,
    this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor statusColor = Colors.grey;
    String statusText = 'Desconocido';
    IconData statusIcon = Icons.help_outline;

    switch (group.state) {
      case GroupState.active:
        statusColor = Colors.green;
        statusText = 'Activo';
        statusIcon = Icons.task_alt;
        break;
      case GroupState.deleted:
        statusColor = Colors.red;
        statusText = 'Eliminado';
        statusIcon = Icons.delete_forever;
        break;
      case GroupState.blocked:
        statusColor = Colors.orange;
        statusText = 'Bloqueado';
        statusIcon = Icons.lock_outline;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.shade300, width: 1.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.shade100,
          child: Icon(statusIcon, color: statusColor.shade700),
        ),
        title: Text('Grupo: ${group.name}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tutor ID: ${group.idTutor}'),
            Text('Edad: ${group.minAge} - ${group.maxAge} años'),
            const SizedBox(height: 4),
            Text(statusText,
                style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (group.state == GroupState.active && onEdit != null)
              IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: onEdit),
            if (group.state == GroupState.active && onBlock != null)
              IconButton(
                  icon: const Icon(Icons.lock, color: Colors.orange),
                  onPressed: onBlock),
            if ((group.state == GroupState.blocked ||
                    group.state == GroupState.deleted) &&
                onRestore != null)
              IconButton(
                  icon: const Icon(Icons.restore, color: Colors.green),
                  onPressed: onRestore),
            if (group.state != GroupState.deleted && onDelete != null)
              IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}