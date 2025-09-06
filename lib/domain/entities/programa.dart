import 'package:pedidos_fundacion/domain/entities/rango_edad.dart';

class Group {
  String id;
  String idCoordinator;
  String groupName;
  AgeRange ageRange;
  DateTime updatedAt;

  Group({
    this.id = '',
    this.idCoordinator = '',
    this.groupName = '',
    required this.ageRange,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idTutor': idCoordinator,
      'groupName': groupName,
      'minAge': ageRange.minAge,
      'maxAge': ageRange.maxAge,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] ?? '',
      idCoordinator: map['idTutor'] ?? '',
      groupName: map['groupName'] ?? '',
      ageRange: AgeRange((map['minAge'] as int), map['maxAge'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Group{id: $id, idTutor: $idCoordinator, groupName: $groupName, '
        'ageRange: ${ageRange.toString()}, updatedAt: ${updatedAt.toIso8601String()}}';
  }
}
