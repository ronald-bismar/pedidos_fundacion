import 'package:image_picker/image_picker.dart';

// ========== CONFIGURACIÓN ÓPTIMA ==========
class OptimalImageConfig {
  static const double maxWidth = 1280; // Ancho máximo
  static const double maxHeight = 1280; // Alto máximo
  static const int imageQuality = 85; // Calidad de compresión
}

Future<XFile?> getImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: OptimalImageConfig.imageQuality,
    maxWidth: OptimalImageConfig.maxWidth,
    maxHeight: OptimalImageConfig.maxHeight,
  );
  return image;
}

Future<XFile?> getImageFromCamera() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: OptimalImageConfig.imageQuality,
    maxWidth: OptimalImageConfig.maxWidth,
    maxHeight: OptimalImageConfig.maxHeight,
    preferredCameraDevice: CameraDevice.rear,
  );
  return image;
}
