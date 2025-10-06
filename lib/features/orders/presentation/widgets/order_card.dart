// lib/features/orders/presentation/screens/order_card.dart

import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final VoidCallback? onBlock;
  final VoidCallback? onUnblock; 
  final VoidCallback? onMarkAsProcessed;
  final VoidCallback? onMarkAsDelivered; 

  const OrderCard({
    super.key,
    required this.order,
    this.onEdit,
    this.onDelete,
    this.onRestore,
    this.onBlock,
    this.onUnblock,        
    this.onMarkAsProcessed, 
    this.onMarkAsDelivered, 
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor statusColor = Colors.grey;
    String statusText = order.state.displayName;
    IconData statusIcon = Icons.help_outline;

    switch (order.state) {
      case OrderState.pending:
        statusColor = Colors.blue;
        statusText = 'Pendiente'; 
        statusIcon = Icons.hourglass_empty;
        break;
      case OrderState.active:
        statusColor = Colors.indigo;
        statusText = 'Activa';
        statusIcon = Icons.check_circle_outline;
        break;
      case OrderState.processed: 
        statusColor = Colors.purple;
        statusText = 'En Proceso';
        statusIcon = Icons.precision_manufacturing_outlined;
        break;
      case OrderState.delivered:
        statusColor = Colors.green;
        statusText = 'Entregada';
        statusIcon = Icons.delivery_dining;
        break;
      case OrderState.cancelled: 
        statusColor = Colors.deepOrange;
        statusText = 'Cancelada';
        statusIcon = Icons.cancel_outlined;
        break;
      case OrderState.blocked:
        statusColor = Colors.orange;
        statusText = 'Bloqueado';
        statusIcon = Icons.lock_outline;
        break;
      case OrderState.deleted:
        statusColor = Colors.red;
        statusText = 'Eliminado';
        statusIcon = Icons.delete_forever;
        break;
      default:
        statusColor = Colors.grey; 
        statusText = 'Desconocido';
        statusIcon = Icons.help_outline;
        break; 
    }

    final formattedTotal = order.totalOrder.toDouble().toStringAsFixed(2);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.shade300, width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: CircleAvatar(
          backgroundColor: statusColor.shade100,
          radius: 25, 
          child: Icon(statusIcon, color: statusColor.shade700, size: 28),
        ),
        title: Text(
          'Pedido: ${order.nameOrder}', 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Tutor: ${order.nameTutor}', style: const TextStyle(fontSize: 13)),
            Text('Grupo: ${order.nameGroup}', style: const TextStyle(fontSize: 13)),
            Text('Fecha: ${order.dateOrderDay}/${order.dateOrderMonth.split(' ')[0]} ${order.dateOrderYear}', style: const TextStyle(fontSize: 13)), 
            Text('Beneficiarios: ${order.beneficiaryCount}', style: const TextStyle(fontSize: 13)), 
            Text('Total: \$$formattedTotal', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(fontSize: 12, color: statusColor.shade800, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String choice) {
            if (choice == 'edit' && onEdit != null) onEdit!();
            if (choice == 'delete' && onDelete != null) onDelete!();
            if (choice == 'restore' && onRestore != null) onRestore!();
            if (choice == 'block' && onBlock != null) onBlock!();
            if (choice == 'unblock' && onUnblock != null) onUnblock!(); 
            if (choice == 'processed' && onMarkAsProcessed != null) onMarkAsProcessed!();
            if (choice == 'delivered' && onMarkAsDelivered != null) onMarkAsDelivered!(); 
          },
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<String>> items = [];

            // Acciones para estado PENDING, ACTIVE, PROCESSED
            if (order.state == OrderState.pending || order.state == OrderState.active || order.state == OrderState.processed) {
              if (onEdit != null) items.add(const PopupMenuItem(value: 'edit', child: Text('Editar Pedido')));
              if (onMarkAsProcessed != null && order.state != OrderState.processed) items.add(const PopupMenuItem(value: 'processed', child: Text('Marcar como Procesada')));
              if (onMarkAsDelivered != null && order.state == OrderState.processed) items.add(const PopupMenuItem(value: 'delivered', child: Text('Marcar como Entregada')));
              if (onBlock != null) items.add(const PopupMenuItem(value: 'block', child: Text('Bloquear Pedido')));
              if (onDelete != null) items.add(const PopupMenuItem(value: 'delete', child: Text('Eliminar Pedido')));
            }
            // Acciones para estado BLOCKED
            else if (order.state == OrderState.blocked) {
              if (onUnblock != null) items.add(const PopupMenuItem(value: 'unblock', child: Text('Desbloquear Pedido')));
              if (onDelete != null) items.add(const PopupMenuItem(value: 'delete', child: Text('Eliminar Pedido')));
            }
            // Acciones para estado DELETED
            else if (order.state == OrderState.deleted && onRestore != null) {
              items.add(const PopupMenuItem(value: 'restore', child: Text('Restaurar Pedido')));
            }
            // Acciones para estado DELIVERED o CANCELLED
            else if (order.state == OrderState.delivered || order.state == OrderState.cancelled) {
              if (onDelete != null) items.add(const PopupMenuItem(value: 'delete', child: Text('Eliminar Pedido')));
            }
            return items;
          },
        ),
      ),
    );
  }
}