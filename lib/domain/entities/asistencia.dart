class Attendance {
  String id;
  String type;
  String idGroup;
  DateTime date;
  String idMonthlyAttendance;

  Attendance({
    this.id = '',
    this.type = '',
    this.idGroup = '',
    required this.date,
    this.idMonthlyAttendance = '',
  });

  @override
  String toString() {
    return 'Attendance{id: $id, type: $type, idGroup: $idGroup, date: $date, idMonthlyAttendance: $idMonthlyAttendance}';
  }

  Attendance copyWith({
    String? id,
    String? type,
    String? idGroup,
    DateTime? date,
    String? idMonthlyAttendance,
  }) {
    return Attendance(
      id: id ?? this.id,
      type: type ?? this.type,
      idGroup: idGroup ?? this.idGroup,
      date: date ?? this.date,
      idMonthlyAttendance: idMonthlyAttendance ?? this.idMonthlyAttendance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'idGroup': idGroup,
      'date': date.toIso8601String().substring(0, 10),
      'idMonthlyAttendance': idMonthlyAttendance,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      idGroup: map['idGroup'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      idMonthlyAttendance: map['idMonthlyAttendance'] ?? '',
    );
  }
}
