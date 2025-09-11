import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';

class OrderListItem extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestore;
  final VoidCallback onBlock;

  const OrderListItem({
    super.key,
    required this.order,
    required this.onEdit,
    required this.onDelete,
    required this.onRestore,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor statusColor = Colors.grey;
    String statusText = 'Desconocido';
    IconData statusIcon = Icons.help_outline;

    switch (order.state) {
      case OrderState.active:
        statusColor = Colors.green;
        statusText = 'Activo';
        statusIcon = Icons.task_alt;
        break;
      case OrderState.deleted:
        statusColor = Colors.red;
        statusText = 'Eliminado';
        statusIcon = Icons.delete_forever;
        break;
      case OrderState.blocked:
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
        side: BorderSide(
          color: statusColor.shade300,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.shade100,
          child: Icon(
            statusIcon,
            color: statusColor.shade700,
          ),
        ),
        title: Text(
          'Pedido de: ${order.nameTutor}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: order.state == OrderState.deleted
                ? Colors.grey.shade600
                : Colors.black87,
            decoration: order.state == OrderState.deleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mes: ${order.dateOrderMonth}',
                style: TextStyle(color: Colors.grey.shade600)),
            Text('Grupo: ${order.nameGroup}',
                style: TextStyle(color: Colors.grey.shade600)),
            Text('Total: \$${order.totalOrder.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.grey.shade600)),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (order.state == OrderState.active)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit,
                tooltip: 'Editar pedido',
              ),
            if (order.state == OrderState.active)
              IconButton(
                icon: const Icon(Icons.lock, color: Colors.orange),
                onPressed: onBlock,
                tooltip: 'Bloquear pedido',
              ),
            if (order.state == OrderState.blocked || order.state == OrderState.deleted) // ✅ Lógica corregida
              IconButton(
                icon: const Icon(Icons.restore, color: Colors.green),
                onPressed: onRestore,
                tooltip: 'Restaurar pedido',
              ),
            if (order.state != OrderState.deleted)
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Eliminar pedido',
              ),
          ],
        ),
      ),
    );
  }
}