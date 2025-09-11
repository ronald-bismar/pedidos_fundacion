import 'package:flutter/material.dart';
import '../../domain/entities/group_entity.dart';

class ConfirmDeleteGroupDialog extends StatelessWidget {
  final GroupEntity groupToDelete;

  const ConfirmDeleteGroupDialog({
    super.key,
    required this.groupToDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text('Confirmar Eliminación de Grupo'),
      content: Text(
        '¿Estás seguro de que quieres eliminar el grupo "${groupToDelete.name}" con el ID de tutor "${groupToDelete.idTutor}"?',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}