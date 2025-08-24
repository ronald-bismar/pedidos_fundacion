// lib/features/orders/presentation/screens/place_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/place_entity.dart';
import '../providers/place_providers.dart';

class PlaceRegistrationScreen extends ConsumerStatefulWidget {
  const PlaceRegistrationScreen({super.key});

  @override
  ConsumerState<PlaceRegistrationScreen> createState() =>
      _PlaceRegistrationScreenState();
}

class _PlaceRegistrationScreenState
    extends ConsumerState<PlaceRegistrationScreen> {
  void _showAddPlaceDialog() {
    final TextEditingController countryController = TextEditingController();
    final TextEditingController departmentController = TextEditingController();
    final TextEditingController provinceController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                    controller: countryController,
                    decoration: InputDecoration(
                      labelText: 'País',
                      hintText: 'Ej. Bolivia',
                      prefixIcon: const Icon(
                        Icons.public,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El país no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: departmentController,
                    decoration: InputDecoration(
                      labelText: 'Departamento',
                      hintText: 'Ej. Tarija',
                      prefixIcon: const Icon(
                        Icons.business_outlined,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El departamento no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: provinceController,
                    decoration: InputDecoration(
                      labelText: 'Provincia',
                      hintText: 'Ej. Gran Chaco',
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La provincia no puede estar vacía.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: 'Ciudad/Comunidad',
                      hintText: 'Ej. La Paz',
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La ciudad/comunidad no puede estar vacía.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
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
                if (formKey.currentState!.validate()) {
                  ref.read(placeProvider.notifier).addPlace(
                        country: countryController.text.trim(),
                        department: departmentController.text.trim(),
                        province: provinceController.text.trim(),
                        city: cityController.text.trim(),
                      );
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Lugar "${cityController.text.trim()}" registrado.'),
                      backgroundColor: Colors.green.shade600,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Registrar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editPlace(PlaceEntity placeToEdit) async {
    final TextEditingController countryController =
        TextEditingController(text: placeToEdit.country);
    final TextEditingController departmentController =
        TextEditingController(text: placeToEdit.department);
    final TextEditingController provinceController =
        TextEditingController(text: placeToEdit.province);
    final TextEditingController cityController =
        TextEditingController(text: placeToEdit.city);
    final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                    controller: countryController,
                    decoration: InputDecoration(
                      labelText: 'País',
                      prefixIcon: const Icon(
                        Icons.public,
                        color: Colors.orange,
                      ),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El país no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: departmentController,
                    decoration: InputDecoration(
                      labelText: 'Departamento',
                      prefixIcon: const Icon(
                        Icons.business_outlined,
                        color: Colors.orange,
                      ),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El departamento no puede estar vacío.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: provinceController,
                    decoration: InputDecoration(
                      labelText: 'Provincia',
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.orange,
                      ),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La provincia no puede estar vacía.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: 'Ciudad/Comunidad',
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: Colors.orange,
                      ),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La ciudad/comunidad no puede estar vacía.';
                      }
                      return null;
                    },
                  ),
                ],
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
                if (editFormKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop({
                    'country': countryController.text.trim(),
                    'department': departmentController.text.trim(),
                    'province': provinceController.text.trim(),
                    'city': cityController.text.trim(),
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      final updatedPlace = placeToEdit.copyWith(
        country: result['country'],
        department: result['department'],
        province: result['province'],
        city: result['city'],
        lastModifiedDate: DateTime.now(),
      );
      ref.read(placeProvider.notifier).updatePlace(updatedPlace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lugar actualizado.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange.shade600,
        ),
      );
    }
  }

  Future<void> _confirmDelete(PlaceEntity placeToDelete) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirmar Eliminación'),
          content: Text(
            '¿Estás seguro de que quieres eliminar el lugar ubicado en "${placeToDelete.city}, ${placeToDelete.department}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
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
          content: Text(
            'Lugar eliminado.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  void _restorePlace(PlaceEntity placeToRestore) {
    ref.read(placeProvider.notifier).restorePlace(placeToRestore.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Lugar restaurado a activo.',
        ),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  void _blockPlace(PlaceEntity placeToBlock) {
    ref.read(placeProvider.notifier).blockPlace(placeToBlock.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lugar bloqueado.'),
        backgroundColor: Colors.orange.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placeProvider);

    final allPlaces = [...places];
    allPlaces.sort((a, b) {
      if (a.state == PlaceState.active && b.state != PlaceState.active) {
        return -1;
      }
      if (a.state != PlaceState.active && b.state == PlaceState.active) {
        return 1;
      }
      if (a.state == PlaceState.blocked && b.state == PlaceState.deleted) {
        return -1;
      }
      if (a.state == PlaceState.deleted && b.state == PlaceState.blocked) {
        return 1;
      }
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Lugares',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  'Lugares Registrados (${allPlaces.length}):',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              const Divider(height: 20, thickness: 1.5, color: Colors.blue),
              Expanded(
                child: allPlaces.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '¡Nada por aquí!\nRegistra tu primer lugar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: allPlaces.length,
                        itemBuilder: (context, index) {
                          final place = allPlaces[index];
                          MaterialColor statusColor;
                          String statusText;
                          IconData statusIcon;

                          switch (place.state) {
                            case PlaceState.active:
                              statusColor = Colors.green;
                              statusText = 'Activo';
                              statusIcon = Icons.location_on;
                              break;
                            case PlaceState.deleted:
                              statusColor = Colors.red;
                              statusText = 'Eliminado';
                              statusIcon = Icons.delete;
                              break;
                            case PlaceState.blocked:
                              statusColor = Colors.orange;
                              statusText = 'Bloqueado';
                              statusIcon = Icons.lock;
                              break;
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 2),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: statusColor.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: statusColor.shade100,
                                child: Icon(
                                  statusIcon,
                                  color: statusColor.shade700,
                                ),
                              ),
                              title: Text(
                                '${place.city}, ${place.department}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: place.state == PlaceState.deleted
                                      ? Colors.grey.shade600
                                      : Colors.black87,
                                  decoration: place.state == PlaceState.deleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'País: ${place.country}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    'Provincia: ${place.province}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (place.state == PlaceState.active)
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.orange.shade700,
                                      ),
                                      onPressed: () => _editPlace(place),
                                      tooltip: 'Editar lugar',
                                    ),
                                  if (place.state == PlaceState.active)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.lock,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _blockPlace(place),
                                      tooltip: 'Bloquear lugar',
                                    ),
                                  if (place.state == PlaceState.blocked ||
                                      place.state == PlaceState.deleted)
                                    IconButton(
                                      icon: Icon(
                                        Icons.restore,
                                        color: Colors.green,
                                      ),
                                      onPressed: () => _restorePlace(place),
                                      tooltip: 'Restaurar lugar',
                                    ),
                                  if (place.state != PlaceState.deleted)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
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
        label: const Text(
          'Nuevo Lugar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}