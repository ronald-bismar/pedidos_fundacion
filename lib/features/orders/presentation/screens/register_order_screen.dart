// lib/features/orders/presentation/pages/register_order_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../groups/domain/entities/group_entity.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../providers/order_providers.dart';

class RegisterOrderScreen extends ConsumerStatefulWidget {
  final GroupEntity selectedGroup;
  final PlaceEntity selectedPlace;

  const RegisterOrderScreen({
    super.key,
    required this.selectedGroup,
    required this.selectedPlace,
  });

  @override
  ConsumerState<RegisterOrderScreen> createState() =>
      _RegisterOrderScreenState();
}

class _RegisterOrderScreenState extends ConsumerState<RegisterOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tutorController = TextEditingController();
  final _orderDateController = TextEditingController();
  final _beneficiaryCountController = TextEditingController();
  final _nonBeneficiaryCountController = TextEditingController();
  final _observationsController = TextEditingController();
  final _totalController = TextEditingController();
  final _orderForDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderDateController.text =
        DateFormat('dd MMMM yyyy', 'es').format(DateTime.now());

    _beneficiaryCountController.addListener(_updateTotal);
    _nonBeneficiaryCountController.addListener(_updateTotal);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final beneficiariesAsyncValue =
        ref.watch(beneficiariesByGroupProvider(widget.selectedGroup.id));
    beneficiariesAsyncValue.whenData((beneficiaries) {
      final activeBeneficiaries =
          beneficiaries.where((b) => b.active).toList();
      _beneficiaryCountController.text = activeBeneficiaries.length.toString();
      _updateTotal();
    });
  }

  void _updateTotal() {
    final beneficiaryCount =
        int.tryParse(_beneficiaryCountController.text) ?? 0;
    final nonBeneficiaryCount =
        int.tryParse(_nonBeneficiaryCountController.text) ?? 0;
    final total = beneficiaryCount + nonBeneficiaryCount;
    _totalController.text = total.toString();
  }

  @override
  void dispose() {
    _tutorController.dispose();
    _orderDateController.dispose();
    _beneficiaryCountController.dispose();
    _nonBeneficiaryCountController.dispose();
    _observationsController.dispose();
    _totalController.dispose();
    _orderForDateController.dispose();

    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(ordersListNotifierProvider.notifier);
      final placeId = widget.selectedPlace.id;

      await notifier.addOrder(
        tutor: _tutorController.text.trim(),
        orderMonth: _orderForDateController.text.trim(),
        programGroup: widget.selectedGroup.name,
        beneficiaryCount:
            int.tryParse(_beneficiaryCountController.text.trim()) ?? 0,
        nonBeneficiaryCount:
            int.tryParse(_nonBeneficiaryCountController.text.trim()) ?? 0,
        observations: _observationsController.text.trim(),
        placeId: placeId,
        

        itemQuantity:
            int.tryParse(_totalController.text.trim()) ?? 0,
        total: double.tryParse(_totalController.text.trim()) ?? 0.0,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Pedido'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Datos Generales'),
              _buildInfoDisplay('Lugar', widget.selectedPlace.city),
              _buildInfoDisplay('Grupo', widget.selectedGroup.name),
              _buildInfoDisplay('Fecha del Pedido (hoy)', _orderDateController.text),
              const SizedBox(height: 16),
              _buildTextFormField(
                _tutorController,
                'Tutor',
                'Ej. Juan Pérez',
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                _orderForDateController,
                'Fecha para el Pedido',
                'Ej.Septiembre ',
              ),
              const SizedBox(height: 16),
              _buildNumericalFormField(
                _beneficiaryCountController,
                'Cantidad de Beneficiarios',
                isReadOnly: true,
              ),
              const SizedBox(height: 16),
              _buildNumericalFormField(
                _nonBeneficiaryCountController,
                'Cantidad de No Beneficiarios',
              ),
              const SizedBox(height: 16),
              _buildNumericalFormField(
                _totalController,
                'Total de Raciones',
                isReadOnly: true,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Observaciones'),
              _buildTextFormField(
                _observationsController,
                'Observaciones',
                '',
                isMultiLine: true,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Pedido'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildInfoDisplay(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller,
      String labelText,
      String hintText, {
        bool isMultiLine = false,
        bool isReadOnly = false,
      }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      maxLines: isMultiLine ? 4 : 1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (!isReadOnly && (value == null || value.trim().isEmpty)) {
          return 'Este campo es obligatorio.';
        }
        return null;
      },
    );
  }

  Widget _buildNumericalFormField(
      TextEditingController controller,
      String labelText, {
        bool isDecimal = false,
        bool isReadOnly = false,
      }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: isDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (!isReadOnly && (value == null || value.trim().isEmpty)) {
          return 'Este campo es obligatorio.';
        }
        if (isDecimal) {
          if (double.tryParse(value!) == null) {
            return 'Introduce un número decimal válido.';
          }
        } else {
          if (int.tryParse(value!) == null) {
            return 'Introduce un número entero válido.';
          }
        }
        return null;
      },
    );
  }
}