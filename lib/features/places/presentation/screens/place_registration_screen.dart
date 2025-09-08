import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/place_entity.dart';
import '../providers/place_providers.dart';
import '../../presentation/widgets/confirm_delete_dialog.dart';
import '../../presentation/widgets/place_form_dialog.dart';
import '../../presentation/widgets/place_list_item.dart'; 

class PlaceRegistrationScreen extends ConsumerStatefulWidget {
  const PlaceRegistrationScreen({super.key});

  @override
  ConsumerState<PlaceRegistrationScreen> createState() =>
      _PlaceRegistrationScreenState();
}

class _PlaceRegistrationScreenState
    extends ConsumerState<PlaceRegistrationScreen> {
  Future<void> _showAddPlaceDialog() async {
    final newPlaceData = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const PlaceFormDialog(),
    );

    if (newPlaceData != null) {
      ref.read(placeProvider.notifier).addPlace(
            country: newPlaceData['country']!,
            department: newPlaceData['department']!,
            province: newPlaceData['province']!,
            city: newPlaceData['city']!,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lugar "${newPlaceData['city']}" registrado.',
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    }
  }

  Future<void> _editPlace(PlaceEntity placeToEdit) async {
    final updatedPlaceData = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => PlaceFormDialog(placeToEdit: placeToEdit),
    );

    if (updatedPlaceData != null) {
      final updatedPlace = placeToEdit.copyWith(
        country: updatedPlaceData['country'],
        department: updatedPlaceData['department'],
        province: updatedPlaceData['province'],
        city: updatedPlaceData['city'],
        lastModifiedDate: DateTime.now(),
      );
      ref.read(placeProvider.notifier).updatePlace(updatedPlace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Lugar actualizado.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange.shade600,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(PlaceEntity placeToDelete) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(placeToDelete: placeToDelete),
    );

    if (confirm == true) {
      ref.read(placeProvider.notifier).deletePlace(placeToDelete.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Lugar eliminado.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _restorePlace(PlaceEntity placeToRestore) {
    ref.read(placeProvider.notifier).restorePlace(placeToRestore);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lugar restaurado a activo.'),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  void _blockPlace(PlaceEntity placeToBlock) {
    ref.read(placeProvider.notifier).blockPlace(placeToBlock.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lugar bloqueado.'),
        backgroundColor: Colors.orange.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placeProvider);

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
                  'Lugares Registrados (${places.length}):',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              const Divider(height: 20, thickness: 1.5, color: Colors.blue),
              Expanded(
                child: places.isEmpty
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
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          final place = places[index];
                          return PlaceListItem(
                            place: place,
                            onEdit: () => _editPlace(place),
                            onDelete: () => _confirmDelete(place),
                            onRestore: () => _restorePlace(place),
                            onBlock: () => _blockPlace(place),
                          ); // Make sure PlaceListItem is a widget class, not a method
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