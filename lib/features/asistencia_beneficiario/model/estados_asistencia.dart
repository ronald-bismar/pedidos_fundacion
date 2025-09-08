enum StateAttendance { attended, notAttended, permission, notRegistered }

extension StateAttendanceExtension on StateAttendance {
  String get value {
    switch (this) {
      case StateAttendance.attended:
        return 'Asistió';
      case StateAttendance.notAttended:
        return 'No asistió';
      case StateAttendance.permission:
        return 'Permiso';
      case StateAttendance.notRegistered:
        return 'No registrado';
    }
  }
}