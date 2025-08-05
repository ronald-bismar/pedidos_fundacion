import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class UploadImageLocal {
  static Future<String> saveImageLocally(
    File tempImage,
    String nameImage,
  ) async {
    // Obtener el directorio de documentos de la aplicación (permanente)
    final Directory privateDir = await getApplicationDocumentsDirectory();

    final Directory imageDir = Directory('${privateDir.path}/NextMacroSystem');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
      log("Created directory: ${imageDir.path}");
    }

    // Generar un nombre de archivo único
    String uniqueFileName = createUniqueName(tempImage, nameImage);

    //Ruta final donde se guardará la imagen
    final String finalPath = '${imageDir.path}/$uniqueFileName';

    //Copiar la imagen temporal a la ruta final
    final File permanentImage = await tempImage.copy(finalPath);

    log("Image saved permanently at: ${permanentImage.path}");

    return permanentImage.path;
  }

  static String createUniqueName(File tempImage, String fileName) {
    // Usar la fecha y hora actual para evitar colisiones
    final DateTime now = DateTime.now();
    final String dateString =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final String timeString =
        '${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
    final String timestamp = '${dateString}_$timeString';
    final String extension = path.extension(tempImage.path);
    final String uniqueFileName = '$fileName-$timestamp$extension';
    return uniqueFileName;
  }

  // Deletes an image at the given path.
  static Future<void> deleteImage(String? imagePath) async {
    try {
      if (imagePath == null || imagePath.isEmpty) {
        return;
      }

      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        log("Image deleted at: $imagePath");
      } else {
        log("Image does not exist at: $imagePath");
      }
    } catch (e) {
      log("Error deleting image: $e");
    }
  }

  static Future<File?> getImageLocal(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    final Directory privateDir = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory('${privateDir.path}/NextMacroSystem');

    if (!imageDir.existsSync()) {
      log("Image directory does not exist: ${imageDir.path}");
      return null;
    }

    final String localImagePath =
        '${imageDir.path}/${path.basename(imagePath)}';
    return File(localImagePath).existsSync() ? File(localImagePath) : null;
  }
}
