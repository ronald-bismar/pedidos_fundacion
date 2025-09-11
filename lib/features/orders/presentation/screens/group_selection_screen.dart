import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../groups/domain/entities/group_entity.dart';
import '../../../places/domain/entities/place_entity.dart';
import '../providers/order_providers.dart';
import '../notifiers/order_state.dart';
import 'beneficiaries_list_screen.dart';

class GroupSelectionScreen extends ConsumerStatefulWidget {
  final PlaceEntity selectedPlace;

  const GroupSelectionScreen({super.key, required this.selectedPlace});

  @override
  ConsumerState<GroupSelectionScreen> createState() =>
      _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends ConsumerState<GroupSelectionScreen> {
  String _getCurrentMonth() {
    return DateFormat('MMMM yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsyncValue = ref.watch(allGroupsProvider);
    final currentMonth = _getCurrentMonth();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Grupo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: groupsAsyncValue.when(
        data: (groups) {
          if (groups.isEmpty) {
            return const Center(child: Text('No hay grupos registrados.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              final hasOrderAsyncValue = ref.watch(
                orderStatusProvider(
                  OrderStatusArgs(groupId: group.id, month: currentMonth),
                ),
              );

              return hasOrderAsyncValue.when(
                data: (hasOrder) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      leading: const Icon(
                        Icons.group,
                        color: Colors.black54,
                        size: 40,
                      ),
                      title: Text(group.name),
                      subtitle: Text(
                        hasOrder ? 'Pedido registrado' : 'Sin pedido',
                      ),
                      trailing: hasOrder
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.red),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BeneficiariesListScreen(
                              selectedGroup: group,
                              selectedPlace: widget.selectedPlace,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) =>
                    const Text('Error al verificar estado del pedido'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Text('Error al cargar grupos: $e'),
      ),
    );
  }
}
