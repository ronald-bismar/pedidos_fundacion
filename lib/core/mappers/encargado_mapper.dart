import 'package:pedidos_fundacion/domain/entities/encargado.dart';

class CoordinatorMapper {
  static Coordinator fromJson(Map<String, dynamic> json) {
    return Coordinator(
      id: json['id'] as String,
      dni: json['dni'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      idPhoto: json['idPhoto'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      profession: json['profession'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  static Map<String, dynamic> toJson(Coordinator coordinator) {
    return {
      'id': coordinator.id,
      'dni': coordinator.dni,
      'name': coordinator.name,
      'lastName': coordinator.lastName,
      'email': coordinator.email,
      'idPhoto': coordinator.idPhoto,
      'username': coordinator.username,
      'password': coordinator.password,
      'phone': coordinator.phone,
      'profession': coordinator.profession,
      'role': coordinator.role,
    };
  }

  static Map<String, dynamic> toJsonPhoto(Coordinator coordinator) {
    return {'idPhoto': coordinator.idPhoto};
  }
}
