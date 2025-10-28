// lib/features/orders/presentation/pages/supervisor_monthly_orders_screen.dart

import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';

class SupervisorMonthlyOrdersScreen extends StatelessWidget {
  final List<OrderEntity> monthlyOrders;
  final String month;

  const SupervisorMonthlyOrdersScreen({
    super.key,
    required this.monthlyOrders,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos de $month', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: monthlyOrders.isEmpty
          ? const Center(child: Text('No hay pedidos para este mes.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: monthlyOrders.length,
              itemBuilder: (context, index) {
                final order = monthlyOrders[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text('Tutor: ${order.nameTutor}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Total: ${order.totalOrder?.toInt() ?? 0}'),
                  ),
                );
              },
            ),
    );
  }
}