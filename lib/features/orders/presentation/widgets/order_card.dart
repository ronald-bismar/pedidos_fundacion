import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final VoidCallback? onBlock;

  const OrderCard({
    super.key,
    required this.order,
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
        side: BorderSide(color: statusColor.shade300, width: 1.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.shade100,
          child: Icon(statusIcon, color: statusColor.shade700),
        ),
        title: Text('Pedido de: ${order.nameTutor}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mes: ${order.dateOrderMonth}'),
            Text('Grupo: ${order.nameGroup}'),
            Text('Total: \$${order.totalOrder.toStringAsFixed(2)}'),
            const SizedBox(height: 4),
            Text(statusText, style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (order.state == OrderState.active && onEdit != null)
              IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: onEdit),
            if (order.state == OrderState.active && onBlock != null)
              IconButton(icon: const Icon(Icons.lock, color: Colors.orange), onPressed: onBlock),
            if ((order.state == OrderState.blocked || order.state == OrderState.deleted) && onRestore != null) // ✅ Lógica corregida
              IconButton(icon: const Icon(Icons.restore, color: Colors.green), onPressed: onRestore),
            if (order.state != OrderState.deleted && onDelete != null)
              IconButton(icon: const Icon(Icons.delete_forever, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}