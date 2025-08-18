class AttendanceBeneficiary {
  String id;
  String idBeneficiary;
  String idAttendance;
  String state;

  AttendanceBeneficiary({
    this.id = '',
    this.idBeneficiary = '',
    this.idAttendance = '',
    this.state = '',
  });

  @override
  String toString() {
    return 'AttendanceBeneficiary{id: $id, idBeneficiary: $idBeneficiary, idAttendance: $idAttendance, state: $state}';
  }

  AttendanceBeneficiary copyWith({
    String? id,
    String? idBeneficiary,
    String? idAttendance,
    String? state,
  }) {
    return AttendanceBeneficiary(
      id: id ?? this.id,
      idBeneficiary: idBeneficiary ?? this.idBeneficiary,
      idAttendance: idAttendance ?? this.idAttendance,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBeneficiary': idBeneficiary,
      'idAttendance': idAttendance,
      'state': state,
    };
  }

  factory AttendanceBeneficiary.fromMap(Map<String, dynamic> map) {
    return AttendanceBeneficiary(
      id: map['id'] ?? '',
      idBeneficiary: map['idBeneficiary'] ?? '',
      idAttendance: map['idAttendance'] ?? '',
      state: map['state'] ?? '',
    );
  }
}
