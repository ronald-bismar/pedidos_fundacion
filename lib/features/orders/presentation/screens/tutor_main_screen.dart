// lib/features/orders/presentation/pages/tutor_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order_entity.dart';
import '../providers/order_providers.dart';
import 'tutor_monthly_orders_screen.dart';

class TutorMainScreen extends ConsumerWidget {
  const TutorMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersListNotifierProvider);
    // Asumiendo que tienes un provider que te da el ID del tutor actual
    // final currentTutorId = ref.watch(currentUserProvider).uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor: Mis Pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ordersState.when(
        data: (orders) {
          // Filtra los pedidos para mostrar solo los del tutor actual
          // final tutorOrders = orders.where((order) => order.nameuser == currentTutorId).toList();
          // Por ahora, usamos un filtro de ejemplo hasta tener el ID de usuario
          final tutorOrders = orders.where((order) => order.nameTutor == 'Juancito Pinto').toList();

          if (tutorOrders.isEmpty) {
            return const Center(child: Text('No has realizado pedidos.', style: TextStyle(color: Colors.grey)));
          }

          final Map<String, List<OrderEntity>> ordersByMonth = {};
          for (var order in tutorOrders) {
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
                        builder: (context) => TutorMonthlyOrdersScreen(
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