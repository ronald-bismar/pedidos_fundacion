// lib/features/orders/presentation/pages/orders_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_providers.dart';
import '../widgets/order_list_item.dart';
import '../widgets/order_form_dialog.dart';
import '../widgets/confirm_delete_order_dialog.dart';
import '../widgets/empty_orders_placeholder.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsyncValue = ref.watch(ordersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pedidos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ordersAsyncValue.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const EmptyOrdersPlaceholder();
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderListItem(
                order: order,
                onEdit: () => _handleEdit(context, ref, order),
                onDelete: () => _handleDelete(context, ref, order),
                onRestore: () => _handleRestore(context, ref, order),
                onBlock: () => _handleBlock(context, ref, order),
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
        child: const Icon(Icons.add),
        tooltip: 'Añadir nuevo pedido',
      ),
    );
  }

  void _handleAdd(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (_) => const OrderFormDialog(),
    );

    if (result != null) {
      final notifier = ref.read(ordersNotifierProvider.notifier);
      await notifier.addOrder(
        tutor: result['tutor'],
        orderMonth: result['orderMonth'],
        programGroup: result['programGroup'],
        beneficiaryCount: result['beneficiaryCount'],
        nonBeneficiaryCount: result['nonBeneficiaryCount'],
        observations: result['observations'],
        itemQuantities: {}, // Ajusta esto según tu lógica de negocio
        total: result['total'],
      );
    }
  }

  void _handleEdit(BuildContext context, WidgetRef ref, OrderEntity order) async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (_) => OrderFormDialog(orderToEdit: order),
    );

    if (result != null) {
      final updatedOrder = OrderEntity(
        id: order.id,
        tutor: result['tutor'],
        orderMonth: result['orderMonth'],
        programGroup: result['programGroup'],
        beneficiaryCount: result['beneficiaryCount'],
        nonBeneficiaryCount: result['nonBeneficiaryCount'],
        observations: result['observations'],
        itemQuantities: order.itemQuantities, // Mantiene los datos existentes
        state: order.state,
        registrationDate: order.registrationDate,
        total: result['total'],
        lastModifiedDate: DateTime.now(),
      );
      final notifier = ref.read(ordersNotifierProvider.notifier);
      await notifier.updateOrder(updatedOrder);
    }
  }

  void _handleDelete(BuildContext context, WidgetRef ref, OrderEntity order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteOrderDialog(orderToDelete: order),
    );

    if (confirm == true) {
      final notifier = ref.read(ordersNotifierProvider.notifier);
      await notifier.deleteOrder(order.id);
    }
  }

  void _handleRestore(BuildContext context, WidgetRef ref, OrderEntity order) async {
    final notifier = ref.read(ordersNotifierProvider.notifier);
    await notifier.restoreOrder(order.id);
  }

  void _handleBlock(BuildContext context, WidgetRef ref, OrderEntity order) async {
    final notifier = ref.read(ordersNotifierProvider.notifier);
    await notifier.blockOrder(order.id);
  }
}