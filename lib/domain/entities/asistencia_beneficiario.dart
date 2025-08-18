class AttendanceBeneficiary {
  String id;
  String idBeneficiary;
  String idAttendance;
  String isAttended;

  AttendanceBeneficiary({
    this.id = '',
    this.idBeneficiary = '',
    this.idAttendance = '',
    this.isAttended = '',
  });

  @override
  String toString() {
    return 'AttendanceBeneficiary{id: $id, idBeneficiary: $idBeneficiary, idAttendance: $idAttendance, isAttended: $isAttended}';
  }

  AttendanceBeneficiary copyWith({
    String? id,
    String? type,
    String? group,
    DateTime? date,
  }) {
    return AttendanceBeneficiary(
      id: id ?? this.id,
      idBeneficiary: idBeneficiary,
      idAttendance: idAttendance,
      isAttended: isAttended,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBeneficiary': idBeneficiary,
      'idAttendance': idAttendance,
      'isAttended': isAttended,
    };
  }

  factory AttendanceBeneficiary.fromMap(Map<String, dynamic> map) {
    return AttendanceBeneficiary(
      id: map['id'] ?? '',
      idBeneficiary: map['idBeneficiary'] ?? '',
      idAttendance: map['idAttendance'] ?? '',
      isAttended: map['isAttended'] ?? '',
    );
  }
}
