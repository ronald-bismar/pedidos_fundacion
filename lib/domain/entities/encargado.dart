import 'usuario.dart';

class Coordinator extends User {
  String profession;
  String role;

  Coordinator({
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
    this.profession = '',
    this.role = '',
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
    return 'Coordinator{profession: $profession, role: $role, ${super.toString()}}';
  }

  Coordinator copyWith({
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
    String? profession,
    String? role,
  }) {
    return Coordinator(
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
      profession: profession ?? this.profession,
      role: role ?? this.role,
    );
  }
}
