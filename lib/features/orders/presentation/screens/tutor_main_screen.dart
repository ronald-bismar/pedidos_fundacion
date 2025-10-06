// lib/features/orders/presentation/pages/tutor_main_screen.dart (Ajuste UI)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/order_entity.dart';
import '../providers/order_providers.dart';
import '../../../encargados/presentation/providers/current_user_provider.dart';

import 'tutor_monthly_orders_screen.dart';
import '../screens/register_general_order_screen.dart';


class TutorMainScreen extends ConsumerWidget {
  const TutorMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsyncValue = ref.watch(currentUserProvider);
    final allOrdersAsyncValue = ref.watch(ordersListNotifierProvider);

    return currentUserAsyncValue.when(
      data: (currentUser) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lista de Pedidos', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
          ),
          body: allOrdersAsyncValue.when(
            data: (allOrders) {
              if (allOrders.isEmpty) {
                return const Center(child: Text('No hay pedidos registrados.', style: TextStyle(color: Colors.grey)));
              }

              final Map<String, List<OrderEntity>> ordersByMonth = {};
              for (var order in allOrders) {
                final month = order.dateOrderMonth;
                if (!ordersByMonth.containsKey(month)) {
                  ordersByMonth[month] = [];
                }
                ordersByMonth[month]!.add(order);
              }

              final sortedMonths = ordersByMonth.keys.toList()
                ..sort((a, b) {
                  try {
                    final DateFormat format = DateFormat('MMMM yyyy', 'es');
                    final DateTime dateA = format.parse(a);
                    final DateTime dateB = format.parse(b);
                    return dateB.compareTo(dateA); 
                  } catch (e) {
                    print('Error parsing month for sorting in TutorMainScreen: $e');
                    return b.compareTo(a); 
                  }
                });

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: sortedMonths.length,
                itemBuilder: (context, index) {
                  final month = sortedMonths[index];
                  final monthlyOrders = ordersByMonth[month]!;

                  final totalPeopleInMonth = monthlyOrders.fold<int>(
                    0,
                    (sum, order) => sum + order.totalOrder,
                  );

                  final uniqueTutorNames = monthlyOrders.map((o) => o.nameTutor).toSet().join(', ');


                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        'Pedidos de ${month}', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Total de beneficiarios: $totalPeopleInMonth\nTutor(es): ${uniqueTutorNames.isEmpty ? 'Desconocido' : uniqueTutorNames}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
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
            error: (error, stack) => Center(child: Text('Error al cargar pedidos: $error')),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterGeneralOrderScreen(),
                ),
              );
            },
            backgroundColor: Colors.amber.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}