// lib/features/orders/presentation/pages/supervisor_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/order_providers.dart';
import 'supervisor_monthly_orders_screen.dart';

class SupervisorMainScreen extends ConsumerWidget {
  const SupervisorMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor: Lista de Pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ordersState.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No hay pedidos registrados.', style: TextStyle(color: Colors.grey)));
          }

          final Map<String, List<OrderEntity>> ordersByMonth = {};
          for (var order in orders) {
            final month = order.dateOrderMonth;
            if (!ordersByMonth.containsKey(month)) {
              ordersByMonth[month] = [];
            }
            ordersByMonth[month]!.add(order);
          }

          final sortedMonths = ordersByMonth.keys.toList()..sort((a, b) => a.compareTo(b));

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sortedMonths.length,
            itemBuilder: (context, index) {
              final month = sortedMonths[index];
              final monthlyOrders = ordersByMonth[month]!;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Pedidos del Mes de $month', style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('${monthlyOrders.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SupervisorMonthlyOrdersScreen(
                          monthlyOrders: monthlyOrders,
                          month: month,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}