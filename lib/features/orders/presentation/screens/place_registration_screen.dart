// lib/features/orders/presentation/screens/place_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/place_entity.dart';
import '../providers/place_providers.dart';

class PlaceRegistrationScreen extends ConsumerStatefulWidget {
  const PlaceRegistrationScreen({super.key});

  @override
  ConsumerState<PlaceRegistrationScreen> createState() => _PlaceRegistrationScreenState();
}

class _PlaceRegistrationScreenState extends ConsumerState<PlaceRegistrationScreen> {

  void _showAddPlaceDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController countryController = TextEditingController();
    final TextEditingController departmentController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Lugar',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre no puede estar vacío.';
                      }
                      final places = ref.read(placeProvider);
                      if (places.any((p) => p.name.trim().toLowerCase() == value.trim().toLowerCase())) {
                        return 'Este lugar ya ha sido registrado.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: countryController,
                    decoration: const InputDecoration(
                      labelText: 'País',
                      prefixIcon: Icon(Icons.public),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El país no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: departmentController,
                    decoration: const InputDecoration(
                      labelText: 'Departamento',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El departamento no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad (Opcional)',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                nameController.dispose();
                countryController.dispose();
                departmentController.dispose();
                cityController.dispose();
              },
              child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final String newPlaceName = nameController.text.trim();
                  ref.read(placeProvider.notifier).addPlace(
                        name: newPlaceName,
                        country: countryController.text.trim(),
                        department: departmentController.text.trim(),
                        city: cityController.text.trim(),
                      );
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lugar "$newPlaceName" registrado.'),
                      backgroundColor: Colors.green.shade600,
                    ),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editPlace(PlaceEntity placeToEdit) async {
    final TextEditingController nameController = TextEditingController(text: placeToEdit.name);
    final TextEditingController countryController = TextEditingController(text: placeToEdit.country);
    final TextEditingController departmentController = TextEditingController(text: placeToEdit.department);
    final TextEditingController cityController = TextEditingController(text: placeToEdit.city);
    final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

    final PlaceEntity? updatedPlace = await showDialog<PlaceEntity>(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nuevo nombre', prefixIcon: Icon(Icons.edit_location)),
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: countryController,
                    decoration: const InputDecoration(labelText: 'País', prefixIcon: Icon(Icons.public)),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El país no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: departmentController,
                    decoration: const InputDecoration(labelText: 'Departamento', prefixIcon: Icon(Icons.business_outlined)),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El departamento no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'Ciudad (Opcional)', prefixIcon: Icon(Icons.location_city)),
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                if (editFormKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(placeToEdit.copyWith(
                    name: nameController.text.trim(),
                    country: countryController.text.trim(),
                    department: departmentController.text.trim(),
                    city: cityController.text.trim().isNotEmpty ? cityController.text.trim() : null,
                  ));
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (updatedPlace != null && updatedPlace != placeToEdit) {
      ref.read(placeProvider.notifier).updatePlace(updatedPlace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lugar actualizado a "${updatedPlace.name}".', style: const TextStyle(color: Colors.white)),
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
          content: Text('¿Estás seguro de que quieres eliminar el lugar "${placeToDelete.name}"?'),
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
      ref.read(placeProvider.notifier).deletePlace(placeToDelete.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lugar "${placeToDelete.name}" marcado como eliminado.'),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha todos los lugares (activos, inactivos, eliminados)
    final places = ref.watch(placeProvider);

    // Filtra los lugares que no están eliminados
    final visiblePlaces = places.where((place) => place.state != PlaceState.deleted).toList();

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
                  'Lugares Registrados (${visiblePlaces.length}):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                ),
              ),
              const Divider(height: 20, thickness: 1.5, color: Colors.blueGrey),
              Expanded(
                child: visiblePlaces.isEmpty
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
                        itemCount: visiblePlaces.length,
                        itemBuilder: (context, index) {
                          final place = visiblePlaces[index];
                          final bool isActive = place.state == PlaceState.active;
                          final bool isInactive = place.state == PlaceState.blocked;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isActive ? Colors.blue.shade100 : Colors.grey.shade300,
                                child: Icon(
                                  isActive ? Icons.place : Icons.visibility_off,
                                  color: isActive ? Colors.blue.shade700 : Colors.grey.shade700,
                                ),
                              ),
                              title: Text(
                                place.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isActive ? Colors.black87 : Colors.grey.shade600,
                                  decoration: isInactive ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                '${place.department}, ${place.country}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
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
                                      isActive ? Icons.visibility_off : Icons.visibility,
                                      color: isActive ? Colors.grey.shade700 : Colors.green.shade700,
                                    ),
                                    onPressed: () {
                                      final notifier = ref.read(placeProvider.notifier);
                                      if (isActive) {
                                        notifier.blockPlace(place.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Lugar "${place.name}" desactivado.'),
                                            backgroundColor: Colors.grey.shade600,
                                          ),
                                        );
                                      } else {
                                        notifier.unblockPlace(place.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Lugar "${place.name}" activado.'),
                                            backgroundColor: Colors.green.shade600,
                                          ),
                                        );
                                      }
                                    },
                                    tooltip: isActive ? 'Desactivar lugar' : 'Activar lugar',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                                    onPressed: () => _confirmDelete(place),
                                    tooltip: 'Eliminar lugar',
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