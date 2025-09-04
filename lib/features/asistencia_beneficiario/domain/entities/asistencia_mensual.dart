class MonthlyAttendance {
  String id;
  String idGroup;
  String nameGroup;
  int month;  
  int year;

  MonthlyAttendance({
    this.id = '',
    this.idGroup = '',
    this.nameGroup = '',
    this.month = 0,
    this.year = 0,
  });

  @override
  String toString() {
    return 'MonthlyAttendance{id: $id, idGroup: $idGroup, nameGroup: $nameGroup, month: $month, year: $year}';
  }

  MonthlyAttendance copyWith({
    String? id,
    String? idGroup,
    String? nameGroup,
    int? month,
    int? year,
  }) {
    return MonthlyAttendance(
      id: id ?? this.id,
      idGroup: idGroup ?? this.idGroup,
      nameGroup: nameGroup ?? this.nameGroup,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idGroup': idGroup,
      'nameGroup': nameGroup,
      'month': month,
      'year': year,
    };
  }

  factory MonthlyAttendance.fromMap(Map<String, dynamic> map) {
    return MonthlyAttendance(
      id: map['id'] ?? '',
      idGroup: map['idGroup'] ?? '',
      nameGroup: map['nameGroup'] ?? '',
      month: map['month'] ?? 0,
      year: map['year'] ?? 0,
    );
  }
}
