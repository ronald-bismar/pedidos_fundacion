// lib/features/orders/presentation/screens/beneficiary_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/beneficiario.dart'; 
import '../../../beneficiarios/presentation/providers/beneficiaries_provider.dart'; 

// Clase para manejar el estado local de un beneficiario con su selección
class SelectableBeneficiary {
  final Beneficiary beneficiary;
  bool isSelected;

  SelectableBeneficiary({required this.beneficiary, this.isSelected = false});
}

class BeneficiaryListScreen extends ConsumerStatefulWidget {
  final String groupId;
  final String groupName;
  final List<String>? initialSelectedBeneficiaryIds;

  const BeneficiaryListScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    this.initialSelectedBeneficiaryIds,
  });

  @override
  ConsumerState<BeneficiaryListScreen> createState() => _BeneficiaryListScreenState();
}

class _BeneficiaryListScreenState extends ConsumerState<BeneficiaryListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<SelectableBeneficiary> _allBeneficiariesWithSelection = []; 
  bool _isInitialized = false; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beneficiariesAsyncValue = ref.watch(beneficiariesStreamProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beneficiarios de ${widget.groupName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.group), text: 'Todos'),
            Tab(icon: Icon(Icons.check_circle_outline), text: 'Seleccionados'),
            Tab(icon: Icon(Icons.cancel_outlined), text: 'No Seleccionados'),
          ],
        ),
      ),
      body: beneficiariesAsyncValue.when(
        data: (beneficiaries) {
          if (!_isInitialized) {
            _allBeneficiariesWithSelection = beneficiaries.map((b) {
              return SelectableBeneficiary(
                beneficiary: b,
                isSelected: widget.initialSelectedBeneficiaryIds?.contains(b.id) ?? false,
              );
            }).toList();
            _isInitialized = true;
          }

          final selectedList = _allBeneficiariesWithSelection.where((b) => b.isSelected).toList();
          final unselectedList = _allBeneficiariesWithSelection.where((b) => !b.isSelected).toList();

          return Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Pestaña "Todos": Muestra la lista principal con selección
                    _buildBeneficiarySelectionList(_allBeneficiariesWithSelection),
                    // Pestaña "Seleccionados": Muestra solo los que tienen isSelected = true
                    _buildBeneficiarySelectionList(selectedList),
                    // Pestaña "No Seleccionados": Muestra solo los que tienen isSelected = false
                    _buildBeneficiarySelectionList(unselectedList),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Devuelve solo los IDs de los beneficiarios seleccionados
                    final resultIds = _allBeneficiariesWithSelection
                        .where((b) => b.isSelected)
                        .map((b) => b.beneficiary.id)
                        .toList();
                    Navigator.of(context).pop(resultIds); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Aceptar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error al cargar beneficiarios: $e', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }

  // Método para construir las listas de beneficiarios con selección
  Widget _buildBeneficiarySelectionList(List<SelectableBeneficiary> list) {
    if (list.isEmpty) {
      String message;
      switch (_tabController.index) {
        case 0:
          message = 'No hay beneficiarios registrados en este grupo.';
          break;
        case 1:
          message = 'No hay beneficiarios seleccionados aún.';
          break;
        case 2:
          message = 'Todos los beneficiarios están seleccionados.';
          break;
        default:
          message = 'No hay datos disponibles.';
      }

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final selectableBeneficiary = list[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          elevation: 2,
          child: ListTile(
            title: Text(selectableBeneficiary.beneficiary.name),
            subtitle: selectableBeneficiary.beneficiary.socialReasson.isNotEmpty
                ? Text(
                    selectableBeneficiary.beneficiary.socialReasson,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  )
                : null,
            trailing: InkWell(
              onTap: () {
                setState(() {
                  selectableBeneficiary.isSelected = !selectableBeneficiary.isSelected;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: selectableBeneficiary.isSelected ? Colors.green.shade500 : Colors.red.shade500,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  selectableBeneficiary.isSelected ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}