import 'package:flutter/material.dart';

import '../../domain/entities/order_entity.dart';

class ConfirmDeleteOrderDialog extends StatelessWidget {
  final OrderEntity orderToDelete;

  const ConfirmDeleteOrderDialog({
    super.key,
    required this.orderToDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text('Confirmar Eliminación de Pedido'),
      content: Text(
        '¿Estás seguro de que quieres eliminar el pedido de "${orderToDelete.tutor}" para el mes de "${orderToDelete.orderMonth}"?',
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