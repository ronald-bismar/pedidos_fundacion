// lib/features/groups/domain/entities/group_entity.dart
import 'package:uuid/uuid.dart';

// Enumerador para los estados del grupo
enum GroupState {
  active,   // 1
  deleted,  // 0
  blocked,  // 2 -> 'Bloqueado'
}

class GroupEntity {
  final String idCluster;
  String nombreGrupo;
  String ageRange;
  GroupState state;
  final DateTime registrationDate;
  DateTime? editedDate;
  DateTime? deleteDate;
  DateTime? restorationDate; // Puedes cambiar el nombre a 'blockedDate' si quieres

  GroupEntity({
    required this.idCluster,
    required this.nombreGrupo,
    required this.ageRange,
    this.state = GroupState.active,
    required this.registrationDate,
    this.editedDate,
    this.deleteDate,
    this.restorationDate,
  });

  GroupEntity copyWith({
    String? idCluster,
    String? nombreGrupo,
    String? ageRange,
    GroupState? state,
    DateTime? registrationDate,
    DateTime? editedDate,
    DateTime? deleteDate,
    DateTime? restorationDate,
  }) {
    return GroupEntity(
      idCluster: idCluster ?? this.idCluster,
      nombreGrupo: nombreGrupo ?? this.nombreGrupo,
      ageRange: ageRange ?? this.ageRange,
      state: state ?? this.state,
      registrationDate: registrationDate ?? this.registrationDate,
      editedDate: editedDate ?? this.editedDate,
      deleteDate: deleteDate ?? this.deleteDate,
      restorationDate: restorationDate ?? this.restorationDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupEntity &&
          runtimeType == other.runtimeType &&
          idCluster == other.idCluster;

  @override
  int get hashCode => idCluster.hashCode;
}