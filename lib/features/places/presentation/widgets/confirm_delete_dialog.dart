import 'package:flutter/material.dart';

import '../../domain/entities/place_entity.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final PlaceEntity placeToDelete;

  const ConfirmDeleteDialog({
    super.key,
    required this.placeToDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text('Confirmar Eliminación'),
      content: Text(
        '¿Estás seguro de que quieres eliminar el lugar ubicado en "${placeToDelete.city}, ${placeToDelete.department}"?',
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