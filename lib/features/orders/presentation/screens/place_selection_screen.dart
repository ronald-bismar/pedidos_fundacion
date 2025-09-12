// lib/features/orders/presentation/screens/place_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../providers/order_providers.dart';
import 'group_selection_screen.dart'; 

class PlaceSelectionScreen extends ConsumerWidget {
  const PlaceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsyncValue = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Lugar'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: placesAsyncValue.when(
        data: (places) {
          if (places.isEmpty) {
            return const Center(child: Text('No hay lugares disponibles.'));
          }

          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    place.city,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(place.city),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupSelectionScreen(selectedPlace: place), 
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar lugares: $e')),
      ),
    );
  }
}