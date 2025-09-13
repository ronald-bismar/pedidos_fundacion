import 'package:flutter/material.dart';

import '../../domain/entities/order_entity.dart';

class OrderFormDialog extends StatefulWidget {
  final OrderEntity? orderToEdit;

  const OrderFormDialog({super.key, this.orderToEdit});

  @override
  State<OrderFormDialog> createState() => _OrderFormDialogState();
}

class _OrderFormDialogState extends State<OrderFormDialog> {
  late final TextEditingController _tutorController;
  late final TextEditingController _orderMonthController;
  late final TextEditingController _programGroupController;
  late final TextEditingController _beneficiaryCountController;
  late final TextEditingController _nonBeneficiaryCountController;
  late final TextEditingController _observationsController;
  late final TextEditingController _totalController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.orderToEdit != null;

  @override
  void initState() {
    super.initState();
    _tutorController =
        TextEditingController(text: widget.orderToEdit?.nameTutor);
    _orderMonthController =
        TextEditingController(text: widget.orderToEdit?.dateOrderMonth);
    _programGroupController =
        TextEditingController(text: widget.orderToEdit?.nameGroup);
    _beneficiaryCountController = TextEditingController(
        text: widget.orderToEdit?.beneficiaryCount.toString());
    _nonBeneficiaryCountController = TextEditingController(
        text: widget.orderToEdit?.nonBeneficiaryCount.toString());
    _observationsController =
        TextEditingController(text: widget.orderToEdit?.observations);
    _totalController =
        TextEditingController(text: widget.orderToEdit?.totalOrder.toString());
  }

  @override
  void dispose() {
    _tutorController.dispose();
    _orderMonthController.dispose();
    _programGroupController.dispose();
    _beneficiaryCountController.dispose();
    _nonBeneficiaryCountController.dispose();
    _observationsController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        isEditing ? 'Editar Pedido' : 'Registrar Nuevo Pedido',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isEditing ? Colors.orange : Colors.blue,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextFormField(
                _tutorController,
                'Tutor',
                'Ej. Juan Pérez',
                Icons.person,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                _orderMonthController,
                'Mes del Pedido',
                'Ej. Septiembre 2024',
                Icons.calendar_month,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                _programGroupController,
                'Grupo de Programa',
                'Ej. Sinergia - Bolivia',
                Icons.group,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildNumericalFormField(
                _beneficiaryCountController,
                'Cantidad de Beneficiarios',
                'Ej. 15',
                Icons.supervised_user_circle,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildNumericalFormField(
                _nonBeneficiaryCountController,
                'Cantidad de No-Beneficiarios',
                'Ej. 5',
                Icons.person_off,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildNumericalFormField(
                _totalController,
                'Total',
                'Ej. 150.00',
                Icons.attach_money,
                isEditing ? Colors.orange : Colors.blue,
                isDecimal: true,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                _observationsController,
                'Observaciones',
                'Ej. Necesita 3 raciones adicionales',
                Icons.notes,
                isEditing ? Colors.orange : Colors.blue,
                isMultiLine: true,
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'tutor': _tutorController.text.trim(),
                'orderMonth': _orderMonthController.text.trim(),
                'programGroup': _programGroupController.text.trim(),
                'beneficiaryCount': int.tryParse(_beneficiaryCountController.text.trim()) ?? 0,
                'nonBeneficiaryCount': int.tryParse(_nonBeneficiaryCountController.text.trim()) ?? 0,
                'observations': _observationsController.text.trim(),
                'total': double.tryParse(_totalController.text.trim()) ?? 0.0,
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isEditing ? Colors.orange.shade700 : Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            isEditing ? 'Guardar' : 'Registrar',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller,
      String labelText,
      String hintText,
      IconData icon,
      Color color, {
        bool isMultiLine = false,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: isMultiLine ? null : 1,
      keyboardType: isMultiLine ? TextInputType.multiline : TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: color.withOpacity(0.1),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El campo no puede estar vacío.';
        }
        return null;
      },
    );
  }
  
  Widget _buildNumericalFormField(
      TextEditingController controller,
      String labelText,
      String hintText,
      IconData icon,
      Color color, {
        bool isDecimal = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: isDecimal ? TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: color.withOpacity(0.1),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El campo no puede estar vacío.';
        }
        if (isDecimal) {
          if (double.tryParse(value) == null) {
            return 'Por favor, introduce un número decimal válido.';
          }
        } else {
          if (int.tryParse(value) == null) {
            return 'Por favor, introduce un número entero válido.';
          }
        }
        return null;
      },
    );
  }
}