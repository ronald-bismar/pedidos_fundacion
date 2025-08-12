import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pedidos_fundacion/core/services/image_storage.dart';

// Clase para manejar la descarga de imágenes
class ImageDownloader {
  static Future<String?> downloadAndSaveImage(
    String imageUrl,
    String fileName,
  ) async {
    try {
      // Descargar la imagen desde la URL
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Crear un archivo temporal con los datos descargados
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath =
            '${tempDir.path}/temp_image${path.extension(imageUrl)}';
        final File tempFile = File(tempPath);
        await tempFile.writeAsBytes(response.bodyBytes);

        // Usar tu clase existente para guardar permanentemente
        final String permanentPath = await UploadImageLocal.saveImageLocally(
          tempFile,
          fileName,
        );

        // Eliminar el archivo temporal
        await tempFile.delete();

        return permanentPath;
      } else {
        log('Error downloading image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error downloading image: $e');
      return null;
    }
  }
}
