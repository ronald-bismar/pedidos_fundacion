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
       );

  String get idCoordinator => id;

  @override
  String toString() {
    return 'Coordinator{profession: $profession, role: $role, ${super.toString()}}';
  }
}
