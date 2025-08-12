import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class UploadImageRemote {
  UploadImageRemote();

  static Future<String?> saveImage(File? image) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dt5rqpa84/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'mhq0qu0h'
        ..files.add(await http.MultipartFile.fromPath('file', image!.path));
      // Enviar la solicitud
      final response = await request.send();
      // Verificar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        final imageUrl = jsonMap['url'];
        return imageUrl;
      } else {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        log('Error response: $responseString');
      }
    } catch (e) {
      log('Exception occurred: $e');
    }
    return null;
  }

  static Future<String?> updateImage(String publicId, File? newImage) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dt5rqpa84/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'mhq0qu0h'
      ..fields['public_id'] = publicId
      ..files.add(await http.MultipartFile.fromPath('file', newImage!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);

        final jsonMap = jsonDecode(responseString);
        final imageUrl = jsonMap['url'];

        return imageUrl;
      } else {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        log('Error response: $responseString');
      }
    } catch (e) {
      log('Exception occurred: $e');
    }
    return null;
  }
}
