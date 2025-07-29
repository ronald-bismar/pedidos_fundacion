import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesUsuarioProvider = Provider((ref) => PreferencesUsuario());

class PreferencesUsuario {
  static const String _keyId = "id";
  static const String _keyDni = "dni";
  static const String _keyName = "name";
  static const String _keyLastname = "lastName";
  static const String _keyEmail = "email";
  static const String _keyIdFoto = "idFoto";
  static const String _keyUsername = "username";
  static const String _keyPassword = "password";
  static const String _keyPhone = "phone";
  static const String _keyProfession = "profession";
  static const String _keyRole = "role";

  Future<void> savePreferencesCoordinator(Coordinator coordinator) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyId, coordinator.id);
    prefs.setString(_keyDni, coordinator.dni);
    prefs.setString(_keyName, coordinator.name);
    prefs.setString(_keyLastname, coordinator.lastName);
    prefs.setString(_keyEmail, coordinator.email);
    prefs.setString(_keyIdFoto, coordinator.idPhoto);
    prefs.setString(_keyUsername, coordinator.username);
    prefs.setString(_keyPassword, coordinator.password);
    prefs.setString(_keyPhone, coordinator.phone);
    prefs.setString(_keyProfession, coordinator.profession);
    prefs.setString(_keyRole, coordinator.role);
  }

  Future<Coordinator> getPreferencesCoordinator() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Coordinator(
      id: prefs.getString(_keyId) ?? '',
      dni: prefs.getString(_keyDni) ?? '',
      name: prefs.getString(_keyName) ?? '',
      lastName: prefs.getString(_keyLastname) ?? '',
      email: prefs.getString(_keyEmail) ?? '',
      idPhoto: prefs.getString(_keyIdFoto) ?? '',
      username: prefs.getString(_keyUsername) ?? '',
      password: prefs.getString(_keyPassword) ?? '',
      phone: prefs.getString(_keyPhone) ?? '',
      profession: prefs.getString(_keyProfession) ?? '',
      role: prefs.getString(_keyRole) ?? '',
    );
  }

  Future<void> clearPreferencesOperario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //Para verificar si el ingreso del coordinator es correcto
  Future<bool> checkLoginOperario(Coordinator coordinator) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString(_keyUsername) ?? '';
    String password = prefs.getString(_keyPassword) ?? '';
    return (username == coordinator.username &&
        password == coordinator.password);
  }
}
