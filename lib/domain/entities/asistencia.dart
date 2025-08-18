class Attendance {
  String id;
  String type;
  String idGroup;
  String nameGroup;
  DateTime date;

  Attendance({
    this.id = '',
    this.type = '',
    this.idGroup = '',
    this.nameGroup = '',
    required this.date,
  });

  @override
  String toString() {
    return 'Attendance{id: $id, type: $type, idGroup: $idGroup, nameGroup: $nameGroup, date: $date}';
  }

  Attendance copyWith({
    String? id,
    String? type,
    String? idGroup,
    String? nameGroup,
    DateTime? date,
  }) {
    return Attendance(
      id: id ?? this.id,
      type: type ?? this.type,
      idGroup: idGroup ?? this.idGroup,
      nameGroup: nameGroup ?? this.nameGroup,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'idGroup': idGroup,
      'nameGroup': nameGroup,
      'date': date.toIso8601String(),
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      idGroup: map['idGroup'] ?? '',
      nameGroup: map['nameGroup'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }
}
