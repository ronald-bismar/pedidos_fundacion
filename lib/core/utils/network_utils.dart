import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkUtils {
  static Future<bool> hasRealInternet() async {
    try {
      // 1. Primero verificar conectividad básica
      final connectivityResult = await Connectivity().checkConnectivity();

      // Si no hay conectividad básica, retornar false
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      // 2. Hacer ping a Google usando HTTP GET con timeout
      final response = await http
          .get(
            Uri.parse('https://www.google.com'),
            headers: {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } on TimeoutException catch (e) {
      log('TimeoutException: $e');
      return false;
    } catch (e) {
      log('Error de conexión: $e');
      return false;
    }
  }
}
