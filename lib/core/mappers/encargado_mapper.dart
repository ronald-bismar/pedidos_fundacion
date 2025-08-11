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
      location: json['location'] as String,
      updateAt: DateTime.parse(
        json['updateAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      active: json['active'] == 1,
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
      'location': coordinator.location,
      'updateAt': coordinator.updateAt.toIso8601String(),
      'active': coordinator.active == true ? 1 : 0,
      'profession': coordinator.profession,
      'role': coordinator.role,
    };
  }

  static Map<String, dynamic> toJsonPhoto(Coordinator coordinator) {
    return {
      'idPhoto': coordinator.idPhoto,
      'updateAt': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> toJsonLocation(Coordinator coordinator) {
    return {
      'location': coordinator.location,
      'updateAt': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> toJsonActive(Coordinator coordinator) {
    return {
      'active': coordinator.active,
      'updateAt': DateTime.now().toIso8601String(),
    };
  }
}
