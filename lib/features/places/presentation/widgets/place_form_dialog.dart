import 'package:flutter/material.dart';

import '../../domain/entities/place_entity.dart';

class PlaceFormDialog extends StatefulWidget {
  final PlaceEntity? placeToEdit;

  const PlaceFormDialog({super.key, this.placeToEdit});

  @override
  State<PlaceFormDialog> createState() => _PlaceFormDialogState();
}

class _PlaceFormDialogState extends State<PlaceFormDialog> {
  late final TextEditingController _countryController;
  late final TextEditingController _departmentController;
  late final TextEditingController _provinceController;
  late final TextEditingController _cityController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.placeToEdit != null;

  @override
  void initState() {
    super.initState();
    _countryController =
        TextEditingController(text: widget.placeToEdit?.country);
    _departmentController =
        TextEditingController(text: widget.placeToEdit?.department);
    _provinceController =
        TextEditingController(text: widget.placeToEdit?.province);
    _cityController = TextEditingController(text: widget.placeToEdit?.city);
  }

  @override
  void dispose() {
    _countryController.dispose();
    _departmentController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
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
        isEditing ? 'Editar Lugar' : 'Registrar Nuevo Lugar',
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
                _countryController,
                'País',
                'Ej. Bolivia',
                Icons.public,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                _departmentController,
                'Departamento',
                'Ej. Tarija',
                Icons.business_outlined,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                _provinceController,
                'Provincia',
                'Ej. Gran Chaco',
                Icons.location_on_outlined,
                isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                _cityController,
                'Ciudad/Comunidad',
                'Ej. La Paz',
                Icons.location_city,
                isEditing ? Colors.orange : Colors.blue,
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
                'country': _countryController.text.trim(),
                'department': _departmentController.text.trim(),
                'province': _provinceController.text.trim(),
                'city': _cityController.text.trim(),
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
    Color color,
  ) {
    return TextFormField(
      controller: controller,
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
}