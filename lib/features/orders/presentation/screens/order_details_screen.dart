// lib/features/orders/presentation/pages/order_details_screen.dart

import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.nameOrder,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Detalles Principales
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIconDetail(Icons.person, 'Tutor:', order.nameTutor, theme),
                    _buildIconDetail(Icons.group, 'Grupo:', order.nameGroup, theme),
                    _buildIconDetail(Icons.location_on, 'Lugar:', order.namePlace, theme),
                    _buildIconDetail(Icons.calendar_today, 'Mes:', order.dateOrderMonth, theme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Sección de Recuento de Beneficiarios
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de Asistencia',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 16),
                    _buildStatRow('Beneficiarios:', order.beneficiaryCount, Colors.green),
                    _buildStatRow('No Beneficiarios:', order.nonBeneficiaryCount, Colors.red),
                    _buildStatRow('Observados:', order.observedBeneficiaryCount, Colors.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sección del Total del Pedido
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total del Pedido',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${order.totalOrder?.toInt() ?? 0}',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sección de Observaciones
            Text(
              'Observaciones:',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                order.observations.isEmpty ? 'Ninguna.' : order.observations,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconDetail(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}