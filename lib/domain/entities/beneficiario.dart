import 'usuario.dart';

class Beneficiary extends User {
  String code;
  String socialReasson;
  String idGroup;
  DateTime birthdate;

  Beneficiary({
    String id = '',
    String dni = '',
    String name = '',
    String lastName = '',
    String email = '',
    String idPhoto = '',
    String username = '',
    String password = '',
    String phone = '',
    String location = '',
    DateTime? updateAt,
    bool active = true,
    this.code = '',
    this.socialReasson = '',
    this.idGroup = '',
    required this.birthdate, // REQUIRED porque todos deben tener fecha de nacimiento
  }) : super(
         id,
         dni,
         name,
         lastName,
         email,
         idPhoto,
         username,
         password,
         phone,
         location,
         updateAt ?? DateTime.now(),
         active,
       );

  String get idCoordinator => id;

  @override
  String toString() {
    return 'Beneficiary{code: $code, socialReasson: $socialReasson, idGroup: $idGroup, birthdate: $birthdate, ${super.toString()}}';
  }

  Beneficiary copyWith({
    String? id,
    String? dni,
    String? name,
    String? lastName,
    String? email,
    String? idPhoto,
    String? username,
    String? password,
    String? phone,
    String? location,
    DateTime? updateAt,
    bool? active,
    String? code,
    String? socialReasson,
    String? idGroup,
    DateTime? birthdate,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      dni: dni ?? this.dni,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      idPhoto: idPhoto ?? this.idPhoto,
      username: username ?? this.username,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      updateAt: updateAt ?? this.updateAt,
      active: active ?? this.active,
      code: code ?? this.code,
      socialReasson: socialReasson ?? this.socialReasson,
      idGroup: idGroup ?? this.idGroup,
      birthdate: birthdate ?? this.birthdate,
    );
  }

  // Métodos útiles para trabajar con la fecha de nacimiento
  // Sacar edad
  int get age {
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  // Obtener un formato mas entendible de fecha de nacimiento
  String get birthdateFormatted {
    return '${birthdate.day.toString().padLeft(2, '0')}/'
        '${birthdate.month.toString().padLeft(2, '0')}/'
        '${birthdate.year}';
  }
}
