// // lib/features/orders/presentation/pages/register_order_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../shared/providers/global_providers.dart';
// import '../providers/order_providers.dart';
// import '../../domain/entities/order_entity.dart';
// import '../../../places/domain/entities/place_entity.dart';
// import '../../../groups/domain/entities/group_entity.dart';

// class RegisterOrderScreen extends ConsumerStatefulWidget {
//   const RegisterOrderScreen({super.key});

//   @override
//   ConsumerState<RegisterOrderScreen> createState() =>
//       _RegisterOrderScreenState();
// }

// class _RegisterOrderScreenState extends ConsumerState<RegisterOrderScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _tutorController = TextEditingController();
//   final _orderMonthController = TextEditingController();
//   final _beneficiaryCountController = TextEditingController();
//   final _nonBeneficiaryCountController = TextEditingController();
//   final _observationsController = TextEditingController();
//   final _totalController = TextEditingController();

//   GroupEntity? _selectedGroup;
//   PlaceEntity? _selectedPlace;

//   @override
//   void dispose() {
//     _tutorController.dispose();
//     _orderMonthController.dispose();
//     _beneficiaryCountController.dispose();
//     _nonBeneficiaryCountController.dispose();
//     _observationsController.dispose();
//     _totalController.dispose();
//     super.dispose();
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedGroup == null || _selectedPlace == null) {
//         // Muestra un SnackBar si no se seleccionó un grupo o lugar
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Por favor, selecciona un grupo y un lugar.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       final notifier = ref.read(ordersNotifierProvider.notifier);

//       await notifier.addOrder(
//         tutor: _tutorController.text.trim(),
//         orderMonth: _orderMonthController.text.trim(),
//         programGroup: _selectedGroup!.name, // Usa el nombre del grupo seleccionado
//         beneficiaryCount: int.tryParse(_beneficiaryCountController.text.trim()) ?? 0,
//         nonBeneficiaryCount: int.tryParse(_nonBeneficiaryCountController.text.trim()) ?? 0,
//         observations: _observationsController.text.trim(),
//         itemQuantities: {}, // Ajusta esto según tu lógica de negocio
//         total: double.tryParse(_totalController.text.trim()) ?? 0.0,
//       );

//       if (mounted) {
//         Navigator.of(context).pop();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final groupsAsyncValue = ref.watch(groupsStreamProvider);
//     final placesAsyncValue = ref.watch(placesStreamProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Registrar Nuevo Pedido'),
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle('Datos Generales'),
//               _buildTextFormField(
//                   _tutorController, 'Tutor', 'Ej. Juan Pérez'),
//               const SizedBox(height: 16),
//               _buildTextFormField(_orderMonthController, 'Mes del Pedido',
//                   'Ej. Septiembre 2024'),
//               const SizedBox(height: 16),
//               groupsAsyncValue.when(
//                 data: (groups) {
//                   return _buildDropdownFormField(
//                     'Grupo',
//                     groups,
//                     _selectedGroup,
//                     (value) {
//                       setState(() {
//                         _selectedGroup = value;
//                       });
//                     },
//                     (group) => group.name,
//                   );
//                 },
//                 loading: () => const Center(child: CircularProgressIndicator()),
//                 error: (e, stack) => Text('Error al cargar grupos: $e'),
//               ),
//               const SizedBox(height: 16),
//               placesAsyncValue.when(
//                 data: (places) {
//                   return _buildDropdownFormField(
//                     'Lugar',
//                     places,
//                     _selectedPlace,
//                     (value) {
//                       setState(() {
//                         _selectedPlace = value;
//                       });
//                     },
//                     (place) => '${place.city}, ${place.department}',
//                   );
//                 },
//                 loading: () => const Center(child: CircularProgressIndicator()),
//                 error: (e, stack) => Text('Error al cargar lugares: $e'),
//               ),
//               const SizedBox(height: 16),
//               _buildNumericalFormField(
//                   _beneficiaryCountController, 'Raciones Beneficiarias'),
//               const SizedBox(height: 16),
//               _buildNumericalFormField(_nonBeneficiaryCountController,
//                   'Raciones no Beneficiarias'),
//               const SizedBox(height: 16),
//               _buildNumericalFormField(
//                   _totalController, 'Total', isDecimal: true),
//               const SizedBox(height: 24),
//               _buildSectionTitle('Observaciones'),
//               _buildTextFormField(
//                   _observationsController, 'Observaciones', '',
//                   isMultiLine: true),
//               const SizedBox(height: 24),
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _submitForm,
//                   icon: const Icon(Icons.save),
//                   label: const Text('Guardar Pedido'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 32, vertical: 16),
//                     textStyle: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//             fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
//       ),
//     );
//   }

//   Widget _buildTextFormField(
//     TextEditingController controller,
//     String labelText,
//     String hintText, {
//     bool isMultiLine = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: isMultiLine ? 4 : 1,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: hintText,
//         border: const OutlineInputBorder(),
//       ),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return 'Este campo es obligatorio.';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildNumericalFormField(
//       TextEditingController controller, String labelText,
//       {bool isDecimal = false}) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: isDecimal
//           ? const TextInputType.numberWithOptions(decimal: true)
//           : TextInputType.number,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return 'Este campo es obligatorio.';
//         }
//         if (isDecimal) {
//           if (double.tryParse(value) == null) {
//             return 'Introduce un número decimal válido.';
//           }
//         } else {
//           if (int.tryParse(value) == null) {
//             return 'Introduce un número entero válido.';
//           }
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildDropdownFormField<T> (
//       String labelText,
//       List<T> items,
//       T? selectedValue,
//       Function(T?) onChanged,
//       String Function(T) itemToString,
//   ) {
//     return DropdownButtonFormField<T>(
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//       value: selectedValue,
//       items: items.map<DropdownMenuItem<T>>((T value) {
//         return DropdownMenuItem<T>(
//           value: value,
//           child: Text(itemToString(value)),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: (value) {
//         if (value == null) {
//           return 'Este campo es obligatorio.';
//         }
//         return null;
//       },
//     );
//   }
// }