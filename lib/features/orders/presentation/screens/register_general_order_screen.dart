// lib/features/orders/screens/register_general_order_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/order_entity.dart';
import '../providers/order_providers.dart';
import '../../../encargados/presentation/providers/current_user_provider.dart';
import 'beneficiary_list_screen.dart';
import '../../../groups/presentation/providers/group_providers.dart' as groups;
import '../../../groups/domain/entities/group_entity.dart';
import '../../domain/usecases/add_order_usecase.dart';
import '../../domain/entities/order_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Clase para encapsular los datos de un grupo en el pedido
class GroupOrderInput {
  String groupId;
  String nameGroup;
  int totalBeneficiaries;
  List<String> selectedBeneficiaryIds;

  GroupOrderInput({
    required this.groupId,
    required this.nameGroup,
    this.totalBeneficiaries = 0,
    this.selectedBeneficiaryIds = const [],
  });

  factory GroupOrderInput.fromGroupEntity(GroupEntity group) {
    return GroupOrderInput(
      groupId: group.id,
      nameGroup: group.name,
      totalBeneficiaries: 0,
      selectedBeneficiaryIds: [],
    );
  }
}

class RegisterGeneralOrderScreen extends ConsumerStatefulWidget {
  const RegisterGeneralOrderScreen({super.key});

  @override
  ConsumerState<RegisterGeneralOrderScreen> createState() => _RegisterGeneralOrderScreenState();
}

class _RegisterGeneralOrderScreenState extends ConsumerState<RegisterGeneralOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pedidoParaController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _orderForMonthController = TextEditingController();
  final TextEditingController _registrationDateController = TextEditingController();
  final TextEditingController _tutorController = TextEditingController();

  DateTime _selectedOrderMonthYear = DateTime.now();

  String? _currentTutorId;
  String? _currentTutorFullName;

  List<GroupOrderInput> _groupOrders = [];
  bool _groupsInitializedFromProvider = false;

  ProviderSubscription? _currentUserListenerDisposer;

  @override
  void initState() {
    super.initState();
    _initializeCurrentUserListener();
    _pedidoParaController.text = 'Canasta'; 
    _updateOrderForMonthText();

    _registrationDateController.text = DateFormat('dd MMMM yyyy', 'es').format(DateTime.now());
  }

  void _initializeCurrentUserListener() {
    _currentUserListenerDisposer = ref.listenManual(currentUserProvider, (previous, next) {
      if (next.value != null && (_currentTutorId == null || _currentTutorId != next.value!.id)) {
        setState(() {
          _currentTutorId = next.value!.id;
          _currentTutorFullName = '${next.value!.name ?? ''} ${next.value!.lastName ?? ''}'.trim();
          if (_currentTutorFullName!.isEmpty) _currentTutorFullName = 'Tutor Actual';
          _tutorController.text = _currentTutorFullName!;
        });
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos del tutor: ${next.error}')),
        );
      }
    }, fireImmediately: true);
  }

  void _updateOrderForMonthText() {
    _orderForMonthController.text = DateFormat('MMMM yyyy', 'es').format(_selectedOrderMonthYear);
  }

  Future<void> _selectOrderMonth(BuildContext context) async {
    DateTime tempSelectedMonthYear = _selectedOrderMonthYear;
    final int currentYear = DateTime.now().year;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final Color primaryBlue = Colors.blue.shade700; 

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), 
                  border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar', style: TextStyle(color: theme.colorScheme.secondary)),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      onPressed: () {
                        setState(() {
                          _selectedOrderMonthYear = DateTime(tempSelectedMonthYear.year, tempSelectedMonthYear.month, 1);
                          _updateOrderForMonthText();
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Confirmar', style: TextStyle(color: primaryBlue)), 
                    ),
                  ],
                ),
              ),
              SizedBox( 
                height: 150, 
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.monthYear,
                  initialDateTime: tempSelectedMonthYear,
                  minimumYear: currentYear - 0, 
                  maximumYear: currentYear + 5,
                  onDateTimeChanged: (DateTime date) {
                    tempSelectedMonthYear = date;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleGroupSelection(GroupOrderInput groupInput) async {
    final List<String>? selectedBeneficiaryIds = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeneficiaryListScreen(
          groupId: groupInput.groupId,
          groupName: groupInput.nameGroup,
          initialSelectedBeneficiaryIds: groupInput.selectedBeneficiaryIds,
        ),
      ),
    );

    if (selectedBeneficiaryIds != null) {
      setState(() {
        groupInput.selectedBeneficiaryIds = selectedBeneficiaryIds;
        groupInput.totalBeneficiaries = selectedBeneficiaryIds.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryBlue = Colors.blue.shade700;
    final Color accentBlue = Colors.lightBlueAccent.shade400;
    final Color errorRed = Colors.redAccent;
    final Color onPrimaryWhite = Colors.white;

    final allGroupsAsyncValue = ref.watch(groups.allGroupsProvider);

    allGroupsAsyncValue.whenData((groupsData) {
      if (!_groupsInitializedFromProvider || _groupOrders.length != groupsData.length ||
          !_groupOrders.every((input) => groupsData.any((g) => g.id == input.groupId))) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              final currentSelected = {for (var g in _groupOrders) g.groupId: g.selectedBeneficiaryIds};
              _groupOrders = groupsData.map((group) {
                final existingInput = currentSelected[group.id];
                return GroupOrderInput(
                  groupId: group.id,
                  nameGroup: group.name,
                  selectedBeneficiaryIds: existingInput ?? [],
                  totalBeneficiaries: existingInput?.length ?? 0,
                );
              }).toList();
              _groupsInitializedFromProvider = true;
            });
          }
        });
      }
    });

    final totalBeneficiariosGlobal = _groupOrders.fold<int>(0, (sum, group) => sum + group.totalBeneficiaries);
    const totalNoBeneficiados = 0; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Pedido'),
        backgroundColor: primaryBlue, 
        foregroundColor: onPrimaryWhite, 
      ),
      body: allGroupsAsyncValue.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryBlue), 
              const SizedBox(height: 16),
              const Text('Cargando grupos disponibles...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: errorRed, size: 48), 
                const SizedBox(height: 16),
                Text(
                  'Error al cargar los grupos: ${e.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: errorRed, fontSize: 16), 
                ),
                const SizedBox(height: 8),
                Text('Por favor, inténtelo de nuevo más tarde.',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
        data: (groupsData) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStyledTextFormField(
                          context,
                          controller: _tutorController,
                          labelText: 'Tutor / Encargado:',
                          hintText: 'Nombre del tutor/encargado',
                          isReadOnly: true,
                          suffixIcon: Icons.person_outline,
                          primaryColor: primaryBlue, 
                        ),
                        _buildStyledTextFormField(
                          context,
                          controller: _pedidoParaController,
                          labelText: 'Nombre del Pedido:',
                          hintText: 'Ej: Canasta de alimentos de Febrero',
                          validator: (value) => value!.isEmpty ? 'Ingrese un nombre para el pedido' : null,
                          suffixIcon: Icons.shopping_basket_outlined,
                          primaryColor: primaryBlue,
                        ),
                        _buildStyledTextFormField(
                          context,
                          controller: _registrationDateController,
                          labelText: 'Fecha de Registro:',
                          hintText: 'Fecha actual del sistema',
                          isReadOnly: true,
                          suffixIcon: Icons.event_note,
                          primaryColor: primaryBlue,
                        ),
                        _buildStyledTextFormField(
                          context,
                          controller: _orderForMonthController,
                          labelText: 'Pedido para el mes:',
                          hintText: 'Selecciona el mes y año del pedido',
                          isReadOnly: true,
                          onTap: () => _selectOrderMonth(context),
                          suffixIcon: Icons.calendar_today,
                          validator: (value) => value!.isEmpty ? 'Seleccione un mes para el pedido' : null,
                          primaryColor: primaryBlue,
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Selecciona beneficiarios por grupo:',
                          style: theme.textTheme.titleLarge?.copyWith(color: primaryBlue), 
                        ),
                        const SizedBox(height: 16),

                        if (_groupOrders.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.group_off, size: 60, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay grupos disponibles en el sistema.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                                  ),
                                  Text(
                                    'Por favor, registre grupos para crear un pedido.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ..._groupOrders.map((groupInput) =>
                              Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => _handleGroupSelection(groupInput),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: accentBlue.withOpacity(0.1), 
                                          radius: 24,
                                          child: Icon(Icons.group, color: accentBlue, size: 28), 
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Grupo: ${groupInput.nameGroup}',
                                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Beneficiarios: ${groupInput.totalBeneficiaries}',
                                                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              )).toList(),
                        const SizedBox(height: 24),

                        _buildStyledTextFormField(
                          context,
                          controller: _observacionesController,
                          labelText: 'Observaciones generales (opcional):',
                          hintText: 'Añadir detalles o notas importantes aquí',
                          maxLines: 3,
                          suffixIcon: Icons.description_outlined,
                          primaryColor: primaryBlue,
                        ),
                        const SizedBox(height: 24),

                        _buildInfoTile(
                          context,
                          'Total beneficiarios seleccionados:',
                          '$totalBeneficiariosGlobal',
                          icon: Icons.people_alt_outlined,
                          valueColor: primaryBlue, 
                        ),
                        _buildInfoTile(
                          context,
                          'Total no beneficiados (observados):',
                          '$totalNoBeneficiados',
                          icon: Icons.person_off_outlined,
                          valueColor: Colors.orange.shade700,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: totalBeneficiariosGlobal > 0 ? _registerOrder : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentBlue, 
                      foregroundColor: onPrimaryWhite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      elevation: 5,
                    ),
                    child: const Text('Registrar Pedido'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String label, String value, {IconData? icon, Color? valueColor}) {
    final theme = Theme.of(context);
    final Color primaryBlue = Colors.blue.shade700; 
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey.shade600),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: valueColor ?? primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextFormField(
      BuildContext context, {
        required TextEditingController controller,
        required String labelText,
        String? hintText,
        String? Function(String?)? validator,
        int maxLines = 1,
        bool isReadOnly = false,
        VoidCallback? onTap,
        IconData? suffixIcon,
        required Color primaryColor, 
      }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        onTap: onTap,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey.shade700),
          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2), 
          ),
          fillColor: isReadOnly ? Colors.grey.shade50 : Colors.white,
          filled: true,
          suffixIcon: suffixIcon != null
              ? Icon(
            suffixIcon,
            color: isReadOnly ? Colors.grey.shade400 : primaryColor,
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }

  void _registerOrder() async {
    if (_formKey.currentState!.validate()) {
      final totalBeneficiariosGlobal = _groupOrders.fold<int>(
        0,
        (sum, group) => sum + group.totalBeneficiaries,
      );
      if (totalBeneficiariosGlobal == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debe seleccionar al menos un beneficiario en algún grupo.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      if (_currentTutorId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo determinar el tutor actual. Por favor, intente de nuevo.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final createOrderUseCase = ref.read(createOrderUseCaseProvider);

      OverlayEntry? overlay;

      try {
        overlay = OverlayEntry(
          builder: (context) => Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.lightBlueAccent.shade400),
                      const SizedBox(height: 20),
                      const Text(
                        'Registrando pedido(s)...',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Esto puede tomar unos segundos',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        Overlay.of(context).insert(overlay);

        final DateTime currentSystemDate = DateTime.now();

        int successfulOrders = 0;
        for (var groupInput in _groupOrders) {
          if (groupInput.totalBeneficiaries > 0) {
            final String orderMonth = DateFormat('MMMM yyyy', 'es').format(_selectedOrderMonthYear);

            final String combinedObservations = [
              _observacionesController.text.trim(),
            ].where((s) => s.isNotEmpty).join('; ');

            String currentPlaceId = 'place_default';
            String currentPlaceName = 'Sede Central';

            final newOrder = OrderEntity(
              id: '',
              nameuser: _currentTutorId!,
              nameTutor: _tutorController.text.trim(),
              nameGroup: groupInput.nameGroup,
              groupId: groupInput.groupId,
              namePlace: currentPlaceName,
              placeId: currentPlaceId,
              nameOrder: _pedidoParaController.text,
              dateOrderMonth: orderMonth,
              dateOrderDay: currentSystemDate.day.toString().padLeft(2, '0'),
              dateOrderYear: currentSystemDate.year.toString(),
              beneficiaryCount: groupInput.totalBeneficiaries,
              nonBeneficiaryCount: 0,
              observedBeneficiaryCount: 0,
              totalOrder: groupInput.totalBeneficiaries,
              itemQuantities: {},
              observations: combinedObservations,
              state: OrderState.pending,
              registrationDate: currentSystemDate,
              lastModifiedDate: DateTime.now(),
            );
            await createOrderUseCase.call(newOrder);
            successfulOrders++;
          }
        }

        overlay.remove();
        if (successfulOrders > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Se registraron $successfulOrders pedido(s) con éxito.'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
          if (mounted && Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ No se pudo registrar ningún pedido. Asegúrese de seleccionar beneficiarios.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (overlay != null) {
          overlay.remove();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al registrar pedido(s): $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _pedidoParaController.clear();
      _observacionesController.clear();
      _registrationDateController.text = DateFormat('dd MMMM yyyy', 'es').format(DateTime.now());
      _selectedOrderMonthYear = DateTime.now();
      _updateOrderForMonthText();

      _groupOrders.clear();
      _groupsInitializedFromProvider = false;

      final currentUser = ref.read(currentUserProvider).value;
      if (currentUser != null) {
        _currentTutorId = currentUser.id;
        _currentTutorFullName = '${currentUser.name ?? ''} ${currentUser.lastName ?? ''}'.trim();
        if (_currentTutorFullName!.isEmpty) _currentTutorFullName = 'Tutor Actual';
        _tutorController.text = _currentTutorFullName!;
      } else {
        _currentTutorId = null;
        _currentTutorFullName = null;
        _tutorController.clear();
      }
    });
  }

  @override
  void dispose() {
    _pedidoParaController.dispose();
    _observacionesController.dispose();
    _orderForMonthController.dispose();
    _registrationDateController.dispose();
    _tutorController.dispose();
    _currentUserListenerDisposer?.close();
    super.dispose();
  }
}