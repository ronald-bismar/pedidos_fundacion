//This class represents a user the who interact directly in first person with application.
class User {
  final String id;
  final String dni;
  final String name;
  final String lastName;
  final String email;
  final String idPhoto;
  final String username;
  final String password;
  final String phone;

  User(
    this.id,
    this.dni,
    this.name,
    this.lastName,
    this.email,
    this.idPhoto,
    this.username,
    this.password,
    this.phone,
  );

  @override
  String toString() {
    return 'User{id: $id, dni: $dni, name: $name, lastName: $lastName, email: $email, idPhoto: $idPhoto, username: $username, phone: $phone}';
  }
}
