// lib/features/orders/presentation/pages/tutor_monthly_orders_screen.dart (Ajuste UI)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order_entity.dart';
import '../screens/register_general_order_screen.dart';

class TutorMonthlyOrdersScreen extends StatelessWidget {
  final List<OrderEntity> monthlyOrders;
  final String month; 

  const TutorMonthlyOrdersScreen({
    super.key,
    required this.monthlyOrders,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final sortedMonthlyOrders = List<OrderEntity>.from(monthlyOrders)
      ..sort((a, b) {
        try {
          final String monthNameA = a.dateOrderMonth.split(' ')[0]; 
          final String monthNameB = b.dateOrderMonth.split(' ')[0]; 
          final int yearA = int.parse(a.dateOrderYear);
          final int yearB = int.parse(b.dateOrderYear);

          // Convertir el nombre del mes a número para DateTime
          final Map<String, int> monthMap = {
            'enero': 1, 'febrero': 2, 'marzo': 3, 'abril': 4, 'mayo': 5, 'junio': 6,
            'julio': 7, 'agosto': 8, 'septiembre': 9, 'octubre': 10, 'noviembre': 11, 'diciembre': 12
          };
          
          final DateTime dateA = DateTime(yearA, monthMap[monthNameA.toLowerCase()]!, int.parse(a.dateOrderDay));
          final DateTime dateB = DateTime(yearB, monthMap[monthNameB.toLowerCase()]!, int.parse(b.dateOrderDay));
          
          return dateB.compareTo(dateA); 
        } catch (e) {
          print('Error parsing date for sorting: $e');
          return 0; 
        }
      });

    final String appBarTitle = 'Pedidos de ${month}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle, 
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: sortedMonthlyOrders.length,
        itemBuilder: (context, index) {
          final order = sortedMonthlyOrders[index];
          
          String formattedDate = 'Fecha N/A';
          try {
            final String monthName = order.dateOrderMonth.split(' ')[0]; 
            final int year = int.parse(order.dateOrderYear);
            final Map<String, int> monthMap = {
              'enero': 1, 'febrero': 2, 'marzo': 3, 'abril': 4, 'mayo': 5, 'junio': 6,
              'julio': 7, 'agosto': 8, 'septiembre': 9, 'octubre': 10, 'noviembre': 11, 'diciembre': 12
            };
            final int monthNumber = monthMap[monthName.toLowerCase()]!;
            final DateTime date = DateTime(year, monthNumber, int.parse(order.dateOrderDay));
            formattedDate = DateFormat('dd-MM-yyyy').format(date);
          } catch (e) {
            print('Error parsing date for display: $e');
          }

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                'Pedido para ${order.nameOrder}', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'Grupo: ${order.nameGroup ?? 'Sin Grupo'}\nFecha: $formattedDate\nTutor: ${order.nameuser}', 
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${order.totalOrder.round()}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              onTap: () {
              },
            ),
          );
        },
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
  }
}