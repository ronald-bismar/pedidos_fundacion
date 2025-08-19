class AttendanceBeneficiary {
  String id;
  String idBeneficiary;
  String nameBeneficiary;
  String idAttendance;
  String state;

  AttendanceBeneficiary({
    this.id = '',
    this.idBeneficiary = '',
    this.nameBeneficiary = '',
    this.idAttendance = '',
    this.state = '',
  });

  @override
  String toString() {
    return 'AttendanceBeneficiary{id: $id, idBeneficiary: $idBeneficiary, nameBeneficiary: $nameBeneficiary, idAttendance: $idAttendance, state: $state}';
  }

  AttendanceBeneficiary copyWith({
    String? id,
    String? nameBeneficiary,
    String? idBeneficiary,
    String? idAttendance,
    String? state,
  }) {
    return AttendanceBeneficiary(
      id: id ?? this.id,
      nameBeneficiary: nameBeneficiary ?? this.nameBeneficiary,
      idBeneficiary: idBeneficiary ?? this.idBeneficiary,
      idAttendance: idAttendance ?? this.idAttendance,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameBeneficiary': nameBeneficiary,
      'idBeneficiary': idBeneficiary,
      'idAttendance': idAttendance,
      'state': state,
    };
  }

  factory AttendanceBeneficiary.fromMap(Map<String, dynamic> map) {
    return AttendanceBeneficiary(
      id: map['id'] ?? '',
      nameBeneficiary: map['nameBeneficiary'] ?? '',
      idBeneficiary: map['idBeneficiary'] ?? '',
      idAttendance: map['idAttendance'] ?? '',
      state: map['state'] ?? '',
    );
  }
}
