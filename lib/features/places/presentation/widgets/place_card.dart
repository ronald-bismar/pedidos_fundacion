import 'package:flutter/material.dart';
import '../../domain/entities/place_entity.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity place;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;
  final VoidCallback? onBlock;

  const PlaceCard({
    super.key,
    required this.place,
    this.onEdit,
    this.onDelete,
    this.onRestore,
    this.onBlock,
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
        side: BorderSide(color: statusColor.shade300, width: 1.5),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.shade100,
          child: Icon(statusIcon, color: statusColor.shade700),
        ),
        title: Text('${place.city}, ${place.department}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('País: ${place.country}'),
            Text('Provincia: ${place.province}'),
            Text(statusText, style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (place.state == PlaceState.active && onEdit != null)
              IconButton(icon: Icon(Icons.edit, color: Colors.orange), onPressed: onEdit),
            if (place.state == PlaceState.active && onBlock != null)
              IconButton(icon: Icon(Icons.lock, color: Colors.orange), onPressed: onBlock),
            if ((place.state == PlaceState.blocked || place.state == PlaceState.deleted) && onRestore != null)
              IconButton(icon: Icon(Icons.restore, color: Colors.green), onPressed: onRestore),
            if (place.state != PlaceState.deleted && onDelete != null)
              IconButton(icon: Icon(Icons.delete_forever, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
