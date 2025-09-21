import 'package:flutter/cupertino.dart';
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
  final _groupNameController = TextEditingController();
  final _placeCityController = TextEditingController();

  String? _selectedOrderType;

  @override
  void initState() {
    super.initState();
    _orderDateController.text = DateFormat(
      'dd MMMM yyyy',
      'es',
    ).format(DateTime.now());

    _groupNameController.text = widget.selectedGroup.name;
    _placeCityController.text = widget.selectedPlace.city;

    _beneficiaryCountController.addListener(_updateTotal);
    _nonBeneficiaryCountController.addListener(_updateTotal);
    _observedBeneficiaryController.addListener(_updateTotal);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser != null && _tutorController.text.isEmpty) {
        _tutorController.text = '${currentUser.name} ${currentUser.lastName}';
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  Future<void> _selectMonth(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final int currentYear = DateTime.now().year;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Fecha para el pedido"),
          content: SizedBox(
            height: 90,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.monthYear,
              initialDateTime: DateTime.now(),
              minimumYear: currentYear,
              maximumYear: currentYear + 1,
              onDateTimeChanged: (DateTime date) {
                selectedDate = date;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final formattedDate = DateFormat(
                    'MMMM yyyy',
                    'es',
                  ).format(selectedDate);
                  _orderForDateController.text =
                      "$formattedDate";
                });
                Navigator.pop(context);
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void _showOrderTypeDialog(BuildContext context) async {
    final selectedType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona el tipo de pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Canasta'),
                onTap: () => Navigator.pop(context, 'Canasta'),
              ),
              ListTile(
                title: const Text('Otros'),
                onTap: () => Navigator.pop(context, 'Otros'),
              ),
            ],
          ),
        );
      },
    );

    if (selectedType != null) {
      setState(() {
        _selectedOrderType = selectedType;
        _orderNameController.text = selectedType;
      });
    }
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
    _orderNameController.dispose();
    _observedBeneficiaryController.dispose();
    _groupNameController.dispose();
    _placeCityController.dispose();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Pedido'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Información del Pedido'),
              const SizedBox(height: 16),
              _buildTextFormField(
                _tutorController,
                'Tutor / Encargado',
                'Nombre del tutor o encargado',
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                _groupNameController,
                'Grupo',
                'Nombre del grupo',
                isReadOnly: true,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                _placeCityController,
                'Lugar',
                'Nombre del lugar',
                isReadOnly: true,
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
                _orderNameController,
                'Pedido de',
                'Selecciona el tipo de pedido',
                isReadOnly: true,
                onTap: () => _showOrderTypeDialog(context),
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                _orderForDateController,
                'Selecciona el mes',
                'Pedido para el mes de',
                isReadOnly: true,
                onTap: () => _selectMonth(context),
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
        }
        return null;
      },
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText,
    String hintText, {
    bool isMultiLine = false,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      maxLines: isMultiLine ? 4 : 1,
      onTap: onTap,
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
}

class MonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const MonthYearPicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late int _displayedYear;

  @override
  void initState() {
    super.initState();
    _displayedYear = widget.initialDate.year;
  }

  void _onMonthSelected(int month) {
    final DateTime selectedDate = DateTime(_displayedYear, month);
    Navigator.of(context).pop(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: 12,
            itemBuilder: (context, monthIndex) {
              final int month = monthIndex + 1;
              final DateTime monthDate = DateTime(_displayedYear, month);

              final bool isCurrentMonth =
                  monthDate.year == DateTime.now().year &&
                  monthDate.month == DateTime.now().month;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () => _onMonthSelected(month),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentMonth ? Colors.blue : null,
                    foregroundColor: isCurrentMonth ? Colors.white : null,
                  ),
                  child: Text(
                    DateFormat('MMMM', 'es').format(monthDate),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                if (_displayedYear > widget.firstDate.year) {
                  setState(() {
                    _displayedYear--;
                  });
                }
              },
            ),
            Text(
              _displayedYear.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                if (_displayedYear < widget.lastDate.year) {
                  setState(() {
                    _displayedYear++;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text(
            'Selecciona el Mes y Año',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
