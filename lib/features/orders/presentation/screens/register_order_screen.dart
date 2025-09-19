import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import '../../../groups/domain/entities/group_entity.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../providers/order_providers.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_state.dart';
import '../../../encargados/presentation/providers/current_user_provider.dart';

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
  final _orderNameController = TextEditingController();
  final _observedBeneficiaryController = TextEditingController();

  // Variable para asegurar que el listener se ejecute una sola vez.
  bool _isListenerSet = false;

  @override
  void initState() {
    super.initState();
    _orderDateController.text = DateFormat(
      'dd MMMM yyyy',
      'es',
    ).format(DateTime.now());

    _beneficiaryCountController.addListener(_updateTotal);
    _nonBeneficiaryCountController.addListener(_updateTotal);
    _observedBeneficiaryController.addListener(_updateTotal);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Esta lógica también puede estar en didChangeDependencies, pero no causa el error de ref.listen
    final beneficiariesAsyncValue = ref.watch(
      beneficiariesByGroupProvider(widget.selectedGroup.id),
    );
    beneficiariesAsyncValue.whenData((beneficiaries) {
      final activeBeneficiaries = beneficiaries.where((b) => b.active).toList();
      _beneficiaryCountController.text = activeBeneficiaries.length.toString();
      _updateTotal();
    });
  }

  void _updateTotal() {
    final beneficiaryCount =
        int.tryParse(_beneficiaryCountController.text) ?? 0;
    final nonBeneficiaryCount =
        int.tryParse(_nonBeneficiaryCountController.text) ?? 0;
    final observedBeneficiaryCount =
        int.tryParse(_observedBeneficiaryController.text) ?? 0;

    final total =
        beneficiaryCount + nonBeneficiaryCount + observedBeneficiaryCount;
    _totalController.text = total.toString();
  }

  @override
  void dispose() {
    // No se necesita `_listener.close()` porque `ref.listen` dentro de `build` se maneja automáticamente
    _tutorController.dispose();
    _orderDateController.dispose();
    _beneficiaryCountController.dispose();
    _nonBeneficiaryCountController.dispose();
    _observationsController.dispose();
    _totalController.dispose();
    _orderForDateController.dispose();
    _orderNameController.dispose();
    _observedBeneficiaryController.dispose();

    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(ordersListNotifierProvider.notifier);
      final currentUser = await ref.read(currentUserProvider.future);
      final currentUserId = currentUser?.id ?? '';

      await notifier.addOrder(
        nameuser: currentUserId,
        nameTutor: _tutorController.text.trim(),
        nameGroup: widget.selectedGroup.name,
        namePlace: widget.selectedPlace.city,
        nameOrder: _orderNameController.text.trim(),
        dateOrderMonth: _orderForDateController.text.trim(),
        beneficiaryCount:
            int.tryParse(_beneficiaryCountController.text.trim()) ?? 0,
        nonBeneficiaryCount:
            int.tryParse(_nonBeneficiaryCountController.text.trim()) ?? 0,
        observedBeneficiaryCount:
            int.tryParse(_observedBeneficiaryController.text.trim()) ?? 0,
        totalOrder: double.tryParse(_totalController.text.trim()) ?? 0.0,
        itemQuantities: {},
        observations: _observationsController.text.trim(),
        placeId: widget.selectedPlace.id,
        groupId: widget.selectedGroup.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pedido registrado con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ CORRECCIÓN: La lógica de ref.listen se mueve aquí para evitar el error
    if (!_isListenerSet) {
      ref.listen<AsyncValue<Coordinator?>>(currentUserProvider, (
        _,
        next,
      ) {
        next.when(
          data: (currentUser) {
            if (currentUser != null && _tutorController.text.isEmpty) {
              _tutorController.text =
                  '${currentUser.name} ${currentUser.lastName}';
            }
          },
          loading: () {},
          error: (error, stackTrace) {},
        );
      });
      _isListenerSet = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Pedido'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Información del Pedido'),
              _buildInfoDisplay('Grupo', widget.selectedGroup.name),
              _buildInfoDisplay('Lugar', widget.selectedPlace.city),
              _buildTextFormField(
                _orderNameController,
                'Nombre del Pedido',
                'Escribe el nombre del pedido',
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                _tutorController,
                'Tutor / Encargado',
                'Nombre del tutor o encargado',
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                _orderDateController,
                'Fecha de Solicitud',
                'dd/mm/yyyy',
                isReadOnly: true,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                _orderForDateController,
                'Fecha para el pedido',
                'Escribe la fecha para la que se hace el pedido',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Números de Personas'),
              _buildNumericalFormField(
                _beneficiaryCountController,
                'N° de Beneficiarios',
                isReadOnly: true,
              ),
              const SizedBox(height: 16),
              _buildNumericalFormField(
                _nonBeneficiaryCountController,
                'N° de No Beneficiarios',
              ),
              const SizedBox(height: 16),
              _buildNumericalFormField(
                _observedBeneficiaryController,
                'N° de Beneficiarios Observados',
              ),
              const SizedBox(height: 16),
              _buildNumericalFormField(
                _totalController,
                'Total',
                isReadOnly: true,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Observaciones'),
              _buildTextFormField(
                _observationsController,
                'Observaciones',
                'Añade cualquier observación relevante',
                isMultiLine: true,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Registrar Pedido'),
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
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
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