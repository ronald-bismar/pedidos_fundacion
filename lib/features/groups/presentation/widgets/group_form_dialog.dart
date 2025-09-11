import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/group_entity.dart';

class GroupFormDialog extends StatefulWidget {
  final GroupEntity? groupToEdit;

  const GroupFormDialog({super.key, this.groupToEdit});

  @override
  State<GroupFormDialog> createState() => _GroupFormDialogState();
}

class _GroupFormDialogState extends State<GroupFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _idTutorController;
  late final TextEditingController _minAgeController;
  late final TextEditingController _maxAgeController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.groupToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.groupToEdit?.name);
    _idTutorController = TextEditingController(text: widget.groupToEdit?.idTutor);
    _minAgeController =
        TextEditingController(text: widget.groupToEdit?.minAge.toString());
    _maxAgeController =
        TextEditingController(text: widget.groupToEdit?.maxAge.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idTutorController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();
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
        isEditing ? 'Editar Grupo' : 'Registrar Nuevo Grupo',
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
                controller: _nameController,
                labelText: 'Nombre del Grupo',
                hintText: 'Ej. Grupo A',
                icon: Icons.group,
                color: isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                controller: _idTutorController,
                labelText: 'ID del Tutor',
                hintText: 'Ej. 12345',
                icon: Icons.person,
                color: isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildNumericalFormField(
                controller: _minAgeController,
                labelText: 'Edad Mínima',
                hintText: 'Ej. 5',
                icon: Icons.timelapse,
                color: isEditing ? Colors.orange : Colors.blue,
              ),
              const SizedBox(height: 15),
              _buildNumericalFormField(
                controller: _maxAgeController,
                labelText: 'Edad Máxima',
                hintText: 'Ej. 12',
                icon: Icons.timelapse,
                color: isEditing ? Colors.orange : Colors.blue,
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
                'name': _nameController.text.trim(),
                'idTutor': _idTutorController.text.trim(),
                'minAge': int.tryParse(_minAgeController.text.trim()) ?? 0,
                'maxAge': int.tryParse(_maxAgeController.text.trim()) ?? 0,
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required Color color,
  }) {
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

  Widget _buildNumericalFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required Color color,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
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
        if (int.tryParse(value) == null) {
          return 'Por favor, introduce un número entero válido.';
        }
        return null;
      },
    );
  }
}