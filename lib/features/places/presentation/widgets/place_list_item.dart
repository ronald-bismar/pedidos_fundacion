import 'package:flutter/material.dart';
import '../../domain/entities/place_entity.dart';

class PlaceListItem extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestore;
  final VoidCallback onBlock;

  const PlaceListItem({
    super.key,
    required this.place,
    required this.onEdit,
    required this.onDelete,
    required this.onRestore,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor statusColor = Colors.grey;
    String statusText = 'Desconocido';
    IconData statusIcon = Icons.help_outline;

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
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
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
            Text('País: ${place.country}',
                style: TextStyle(color: Colors.grey.shade600)),
            Text('Provincia: ${place.province}',
                style: TextStyle(color: Colors.grey.shade600)),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (place.isSyncedToLocal)
                  const Tooltip(
                    message: 'Guardado localmente',
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  )
                else
                  const Tooltip(
                    message: 'Pendiente de guardar localmente',
                    child: Icon(
                      Icons.save_outlined,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                const SizedBox(width: 8),
                if (place.isSyncedToFirebase)
                  const Tooltip(
                    message: 'Sincronizado con Firebase',
                    child: Icon(
                      Icons.cloud_done,
                      color: Colors.blue,
                      size: 20,
                    ),
                  )
                else
                  const Tooltip(
                    message: 'Pendiente de sincronizar',
                    child: Icon(
                      Icons.cloud_upload,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (place.state == PlaceState.active)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit,
                tooltip: 'Editar lugar',
              ),
            if (place.state == PlaceState.active)
              IconButton(
                icon: const Icon(Icons.lock, color: Colors.orange),
                onPressed: onBlock,
                tooltip: 'Bloquear lugar',
              ),
            if (place.state == PlaceState.blocked ||
                place.state == PlaceState.deleted)
              IconButton(
                icon: const Icon(Icons.restore, color: Colors.green),
                onPressed: onRestore,
                tooltip: 'Restaurar lugar',
              ),
            if (place.state != PlaceState.deleted)
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: onDelete,
                tooltip: 'Eliminar lugar',
              ),
          ],
        ),
      ),
    );
  }
}
