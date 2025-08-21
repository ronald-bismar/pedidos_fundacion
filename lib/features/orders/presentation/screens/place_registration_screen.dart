// lib/features/orders/presentation/screens/place_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:pedidos_fundacion/features/orders/domain/entities/place_entity.dart';
import '../../../../features/orders/domain/entities/place_entity.dart';
import '../../../../features/orders/presentation/providers/place_providers.dart';



class PlaceRegistrationScreen extends ConsumerStatefulWidget {
  const PlaceRegistrationScreen({super.key});

  @override
  ConsumerState<PlaceRegistrationScreen> createState() => _PlaceRegistrationScreenState();
}

class _PlaceRegistrationScreenState extends ConsumerState<PlaceRegistrationScreen> {

  // Método para mostrar el diálogo de agregar lugar con nuevo diseño
  void _showAddPlaceDialog() {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Registrar Nuevo Lugar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Nombre del Lugar',
                  hintText: 'Ej. Achica, Pochohota',
                  prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre del lugar no puede estar vacío.';
                  }
                  final places = ref.read(placeProvider);
                  if (places.any((p) => p.name.trim().toLowerCase() == value.trim().toLowerCase())) {
                    return 'Este lugar ya ha sido registrado.';
                  }
                  return null;
                },
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                controller.dispose();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final String newPlaceName = controller.text.trim();
                  ref.read(placeProvider.notifier).addPlace(newPlaceName);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lugar "$newPlaceName" registrado.'),
                      backgroundColor: Colors.green.shade600,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Registrar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editPlace(PlaceEntity placeToEdit) async {
    final TextEditingController editController = TextEditingController(text: placeToEdit.name);
    final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

    final String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Editar Lugar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: editFormKey,
              child: TextFormField(
                controller: editController,
                decoration: InputDecoration(
                  labelText: 'Nuevo nombre',
                  hintText: 'Ingrese el nuevo nombre del lugar',
                  prefixIcon: const Icon(Icons.edit_location, color: Colors.orange),
                  filled: true,
                  fillColor: Colors.orange.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.orange.shade200, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre no puede estar vacío.';
                  }
                  final normalizedNewName = value.trim().toLowerCase();
                  final existingPlaces = ref.read(placeProvider);
                  if (existingPlaces.any((p) => p.id != placeToEdit.id && p.name.trim().toLowerCase() == normalizedNewName)) {
                    return 'Este nombre de lugar ya existe.';
                  }
                  return null;
                },
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                if (editFormKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(editController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty && newName != placeToEdit.name) {
      final updatedPlace = placeToEdit.copyWith(name: newName);
      ref.read(placeProvider.notifier).updatePlace(updatedPlace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lugar actualizado a "$newName".', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }


  Future<void> _confirmDelete(PlaceEntity placeToDelete) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar el lugar "${placeToDelete.name}"? Esta acción es permanente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.blueGrey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      ref.read(placeProvider.notifier).removePlace(placeToDelete.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lugar "${placeToDelete.name}" eliminado.', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Lugares', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Lugares Registrados (${places.length}):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                ),
              ),
              const Divider(height: 20, thickness: 1.5, color: Colors.blueGrey),
              Expanded(
                child: places.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 10),
                            Text(
                              '¡Nada por aquí!\nRegistra tu primer lugar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          final place = places[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: place.isActive ? Colors.blue.shade100 : Colors.grey.shade300,
                                child: Icon(
                                  place.isActive ? Icons.place : Icons.visibility_off,
                                  color: place.isActive ? Colors.blue.shade700 : Colors.grey.shade700,
                                ),
                              ),
                              title: Text(
                                place.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: place.isActive ? Colors.black87 : Colors.grey.shade600,
                                  decoration: place.isActive ? TextDecoration.none : TextDecoration.lineThrough,
                                ),
                              ),
                              subtitle: place.isActive
                                  ? null
                                  : const Text('Inactivo', style: TextStyle(fontSize: 12, color: Colors.red)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.orange.shade700),
                                    onPressed: () => _editPlace(place),
                                    tooltip: 'Editar lugar',
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      place.isActive ? Icons.visibility_off : Icons.visibility,
                                      color: place.isActive ? Colors.grey.shade700 : Colors.green.shade700,
                                    ),
                                    onPressed: () {
                                      ref.read(placeProvider.notifier).togglePlaceActiveStatus(place.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            place.isActive ? 'Lugar "${place.name}" desactivado.' : 'Lugar "${place.name}" activado.',
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: place.isActive ? Colors.grey.shade600 : Colors.green.shade600,
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    tooltip: place.isActive ? 'Desactivar lugar' : 'Activar lugar',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                                    onPressed: () => _confirmDelete(place),
                                    tooltip: 'Eliminar lugar permanentemente',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPlaceDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nuevo Lugar', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}