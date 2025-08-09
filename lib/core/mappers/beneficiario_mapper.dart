import 'package:pedidos_fundacion/domain/entities/beneficiario.dart';

class BeneficiaryMapper {
  static Beneficiary fromJson(Map<String, dynamic> json) {
    return Beneficiary(
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
      code: json['code'] as String? ?? '',
      socialReasson: json['socialReasson'] as String? ?? '',
      idGroup: json['idGroup'] as String? ?? '',
      birthdate: DateTime.parse(
        json['birthdate'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static Map<String, dynamic> toJson(Beneficiary beneficiary) {
    return {
      'id': beneficiary.id,
      'dni': beneficiary.dni,
      'name': beneficiary.name,
      'lastName': beneficiary.lastName,
      'email': beneficiary.email,
      'idPhoto': beneficiary.idPhoto,
      'username': beneficiary.username,
      'password': beneficiary.password,
      'phone': beneficiary.phone,
      'location': beneficiary.location,
      'updateAt': beneficiary.updateAt.toIso8601String(),
      'active': beneficiary.active == true ? 1 : 0,
      'code': beneficiary.code,
      'socialReasson': beneficiary.socialReasson,
      'idGroup': beneficiary.idGroup,
      'birthdate': beneficiary.birthdate.toIso8601String(),
    };
  }

  static Map<String, dynamic> toJsonPhoto(Beneficiary beneficiary) {
    return {'idPhoto': beneficiary.idPhoto, 'updateAt': DateTime.now()};
  }

  static Map<String, dynamic> toJsonLocationAndPhone(Beneficiary beneficiary) {
    return {
      'location': beneficiary.location,
      'phone': beneficiary.phone,
      'updateAt': DateTime.now(),
    };
  }

  static Map<String, dynamic> toJsonActive(Beneficiary beneficiary) {
    return {'active': beneficiary.active, 'updateAt': DateTime.now()};
  }

  static Map<String, dynamic> toJsonCode(Beneficiary beneficiary) {
    return {'code': beneficiary.code, 'updateAt': DateTime.now()};
  }

  static Map<String, dynamic> toJsonGroup(Beneficiary beneficiary) {
    return {'idGroup': beneficiary.active, 'updateAt': DateTime.now()};
  }
}
