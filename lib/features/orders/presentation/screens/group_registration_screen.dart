// lib/features/groups/presentation/screens/group_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/group_entity.dart';
import '../providers/group_providers.dart';

class GroupRegistrationScreen extends ConsumerStatefulWidget {
  const GroupRegistrationScreen({super.key});

  @override
  ConsumerState<GroupRegistrationScreen> createState() =>
      _GroupRegistrationScreenState();
}

class _GroupRegistrationScreenState
    extends ConsumerState<GroupRegistrationScreen> {
  void _showAddGroupDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageRangeController = TextEditingController();
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
            'Registrar Nuevo Grupo',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Grupo',
                      hintText: 'Ej. Jóvenes Líderes',
                      prefixIcon: const Icon(Icons.group, color: Colors.purple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.purple.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre del grupo no puede estar vacío.';
                      }
                      final groups = ref.read(groupProvider);
                      if (groups.any(
                        (g) =>
                            g.nombreGrupo.trim().toLowerCase() ==
                            value.trim().toLowerCase(),
                      )) {
                        return 'Este grupo ya ha sido registrado.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: ageRangeController,
                    decoration: InputDecoration(
                      labelText: 'Rango de Edad',
                      hintText: 'Ej. 18-25',
                      prefixIcon: const Icon(Icons.cake, color: Colors.purple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.purple.shade50,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El rango de edad no puede estar vacío.';
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
                  final String newGroupName = nameController.text.trim();
                  final String newAgeRange = ageRangeController.text.trim();
                  ref
                      .read(groupProvider.notifier)
                      .addGroup(newGroupName, newAgeRange);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Grupo "$newGroupName" registrado.'),
                      backgroundColor: Colors.green.shade600,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
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

  Future<void> _editGroup(GroupEntity groupToEdit) async {
    final TextEditingController nameController = TextEditingController(
      text: groupToEdit.nombreGrupo,
    );
    final TextEditingController ageRangeController = TextEditingController(
      text: groupToEdit.ageRange,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Editar Grupo',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nuevo nombre',
                      prefixIcon: const Icon(Icons.edit, color: Colors.orange),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre no puede estar vacío.';
                      }
                      final normalizedNewName = value.trim().toLowerCase();
                      final existingGroups = ref.read(groupProvider);
                      if (existingGroups.any(
                        (g) =>
                            g.idCluster != groupToEdit.idCluster &&
                            g.nombreGrupo.trim().toLowerCase() ==
                                normalizedNewName,
                      )) {
                        return 'Este nombre de grupo ya existe.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: ageRangeController,
                    decoration: InputDecoration(
                      labelText: 'Nuevo rango de edad',
                      prefixIcon: const Icon(Icons.edit, color: Colors.orange),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El rango de edad no puede estar vacío.';
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
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop({
                    'name': nameController.text.trim(),
                    'ageRange': ageRangeController.text.trim(),
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      final updatedGroup = groupToEdit.copyWith(
        nombreGrupo: result['name']!,
        ageRange: result['ageRange']!,
      );
      ref.read(groupProvider.notifier).updateGroup(updatedGroup);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Grupo "${result['name']}" actualizado.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange.shade600,
        ),
      );
    }
  }

  Future<void> _confirmDelete(GroupEntity groupToDelete) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirmar Eliminación'),
          content: Text(
            '¿Estás seguro de que quieres eliminar el grupo "${groupToDelete.nombreGrupo}"?',
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
      ref.read(groupProvider.notifier).deleteGroup(groupToDelete.idCluster);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Grupo "${groupToDelete.nombreGrupo}" eliminado.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  void _restoreGroup(GroupEntity groupToRestore) {
    ref.read(groupProvider.notifier).unblockGroup(groupToRestore.idCluster);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Grupo "${groupToRestore.nombreGrupo}" restaurado a activo.',
        ),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }

  void _blockGroup(GroupEntity groupToBlock) {
    ref.read(groupProvider.notifier).blockGroup(groupToBlock.idCluster);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Grupo "${groupToBlock.nombreGrupo}" bloqueado.'),
        backgroundColor: Colors.orange.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupProvider);
    final allGroups = [
      ...groups.where((g) => g.state == GroupState.active),
      ...groups.where((g) => g.state == GroupState.blocked),
      ...groups.where((g) => g.state == GroupState.deleted),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Grupos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade50, Colors.purple.shade100],
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
                  'Grupos Registrados (${allGroups.length}):',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                  ),
                ),
              ),
              const Divider(height: 20, thickness: 1.5, color: Colors.blue),
              Expanded(
                child: allGroups.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_off,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '¡Nada por aquí!\nRegistra tu primer grupo.',
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
                        itemCount: allGroups.length,
                        itemBuilder: (context, index) {
                          final group = allGroups[index];
                          MaterialColor statusColor;
                          String statusText;
                          IconData statusIcon;

                          switch (group.state) {
                            case GroupState.active:
                              statusColor = Colors.green;
                              statusText = 'Activo';
                              statusIcon = Icons.group;
                              break;
                            case GroupState.deleted:
                              statusColor = Colors.red;
                              statusText = 'Eliminado';
                              statusIcon = Icons.delete;
                              break;
                            case GroupState.blocked:
                              statusColor = Colors.orange;
                              statusText = 'Bloqueado';
                              statusIcon = Icons.lock;
                              break;
                            default:
                              statusColor = Colors.grey;
                              statusText = 'Desconocido';
                              statusIcon = Icons.help_outline;
                              break;
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 2,
                            ),
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
                                group.nombreGrupo,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: group.state == GroupState.deleted
                                      ? Colors.grey.shade600
                                      : Colors.black87,
                                  decoration: group.state == GroupState.deleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rango de edad: ${group.ageRange}',
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
                                  if (group.state == GroupState.active)
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.orange.shade700,
                                      ),
                                      onPressed: () => _editGroup(group),
                                      tooltip: 'Editar grupo',
                                    ),
                                  if (group.state == GroupState.active)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.lock,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _blockGroup(group),
                                      tooltip: 'Bloquear grupo',
                                    ),
                                  if (group.state == GroupState.blocked)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.lock_open,
                                        color: Colors.green,
                                      ),
                                      onPressed: () => _restoreGroup(group),
                                      tooltip: 'Desbloquear grupo',
                                    ),
                                  if (group.state != GroupState.deleted)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _confirmDelete(group),
                                      tooltip: 'Eliminar grupo',
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
        onPressed: _showAddGroupDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nuevo Grupo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple.shade700,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
