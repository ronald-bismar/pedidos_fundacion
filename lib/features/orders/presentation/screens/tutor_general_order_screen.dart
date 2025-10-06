// lib/features/orders/presentation/pages/tutor_general_order_screen.dart (CORREGIDO - V2)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; 

import '../../domain/entities/order_entity.dart';
import '../../../groups/domain/entities/group_entity.dart';
import '../../../groups/presentation/providers/group_providers.dart';
import '../../../encargados/presentation/providers/current_user_provider.dart';

import '../screens/register_general_order_screen.dart'; 

final groupsByTutorProvider = StreamProvider.family<List<GroupEntity>, String>((
  ref,
  tutorId,
) {
  final getGroupsByTutorUseCase = ref.read(getGroupsByTutorUseCaseProvider);
  return getGroupsByTutorUseCase.call(tutorId);
});

class TutorGeneralOrderScreen extends ConsumerWidget {
  final List<OrderEntity> monthlyOrders;
  final String month;

  const TutorGeneralOrderScreen({
    super.key,
    required this.monthlyOrders,
    required this.month,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsyncValue = ref.watch(currentUserProvider);

    final sortedMonthlyOrders = List<OrderEntity>.from(monthlyOrders)
      ..sort((a, b) => b.id.compareTo(a.id)); 

    return currentUserAsyncValue.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Center(child: Text('Tutor no encontrado.'));
        }

        final groupsAsyncValue = ref.watch(groupsByTutorProvider(currentUser.id!));

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Pedidos de $month',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Resumen general de todos los pedidos ya registrados para el mes
                if (sortedMonthlyOrders.isNotEmpty)
                  _buildSummaryCard(sortedMonthlyOrders)
                else
                  const Center(child: Text('No hay pedidos registrados para este mes.')),
                const SizedBox(height: 20),

                // 2. Título para la sección de grupos
                const Text(
                  'Gestionar Pedidos por Grupo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),

                // 3. Lista de grupos del tutor (para crear/modificar pedidos)
                groupsAsyncValue.when(
                  data: (groups) {
                    if (groups.isEmpty) {
                      return const Center(child: Text('No hay grupos asignados a este tutor.'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        // Verificar si existe un pedido pendiente para este grupo en la lista monthlyOrders
                        final hasExistingOrderForGroup = sortedMonthlyOrders.any((order) => order.groupId == group.id);

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(
                              Icons.group,
                              color: Colors.blue,
                              size: 30,
                            ),
                            title: Text(
                              group.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              hasExistingOrderForGroup ? 'Pedido registrado este mes' : 'Sin pedido para este mes',
                              style: TextStyle(
                                color: hasExistingOrderForGroup ? Colors.green : Colors.red,
                              ),
                            ),
                            trailing: Icon(
                              hasExistingOrderForGroup ? Icons.edit : Icons.add_circle_outline,
                              color: hasExistingOrderForGroup ? Colors.orange : Colors.grey,
                            ),
                            onTap: () {
                              // Navegar a GeneralOrderScreen, que es el formulario de creación/edición
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterGeneralOrderScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error al cargar grupos: $error')),
                ),
                const SizedBox(height: 20),

              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildSummaryCard(List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }
    final firstOrder = orders.first; 
    final totalBeneficiaries = orders.fold<int>(
      0,
      (sum, order) => sum + order.beneficiaryCount,
    );
    final totalNonBeneficiaries = orders.fold<int>(
      0,
      (sum, order) => sum + order.nonBeneficiaryCount,
    );
    final totalObserved = orders.fold<int>(
      0,
      (sum, order) => sum + (order.observedBeneficiaryCount ?? 0),
    );
    final totalOverall = orders.fold<double>(
      0.0,
      (sum, order) => sum + order.totalOrder,
    );
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.person, 'Tutor', firstOrder.nameTutor),
            _buildInfoRow(Icons.calendar_month, 'Mes', month),
            const Divider(),
            _buildSectionTitle('Resumen de Asistencia General'),
            _buildSummaryRow('Beneficiarios:', totalBeneficiaries),
            _buildSummaryRow('No Beneficiarios:', totalNonBeneficiaries),
            _buildSummaryRow('Observados:', totalObserved),
            const SizedBox(height: 10),
            _buildSectionTitle('Total General de Personas'),
            _buildSummaryRow('Total:', totalOverall.round()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}