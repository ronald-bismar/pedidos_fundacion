// lib/features/orders/presentation/screens/beneficiaries_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/beneficiario.dart';
import '../../../groups/domain/entities/group_entity.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../providers/order_providers.dart';
import '../screens/register_order_screen.dart';

class BeneficiariesListScreen extends ConsumerWidget {
  final PlaceEntity selectedPlace;
  final GroupEntity selectedGroup;

  const BeneficiariesListScreen({
    super.key,
    required this.selectedPlace,
    required this.selectedGroup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beneficiariesAsyncValue = ref.watch(beneficiariesByGroupProvider(selectedGroup.id));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Beneficiarios de ${selectedGroup.name}'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 168, 169, 169),
            tabs: const [
              Tab(icon: Icon(Icons.group), text: 'Todos'),
              Tab(icon: Icon(Icons.check_circle_outline), text: 'Beneficiarios'),
              Tab(icon: Icon(Icons.cancel_outlined), text: 'No Beneficiarios'),
            ],
          ),
        ),
        body: beneficiariesAsyncValue.when(
          data: (beneficiaries) {
            final beneficiaryList = beneficiaries.where((b) => b.active).toList();
            final nonBeneficiaryList = beneficiaries.where((b) => !b.active).toList();

            return TabBarView(
              children: [
                _buildBeneficiaryList(beneficiaries),
                _buildBeneficiaryList(beneficiaryList),
                _buildBeneficiaryList(nonBeneficiaryList),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error al cargar beneficiarios: $e')),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RegisterOrderScreen(
                  selectedGroup: selectedGroup,
                  selectedPlace: selectedPlace,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: const Text('Registrar Pedido', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildBeneficiaryList(List<Beneficiary> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No hay registros en esta lista.'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final beneficiary = list[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListTile(
            title: Text(beneficiary.name),
            subtitle: Text(beneficiary.socialReasson),
            trailing: beneficiary.active
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.cancel, color: Colors.red),
          ),
        );
      },
    );
  }
}