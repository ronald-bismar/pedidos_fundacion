import 'package:image_picker/image_picker.dart';

Future<XFile?> getImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

Future<XFile?> getImageFromCamera() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80,
    maxWidth: 800,
    maxHeight: 800,
  );
  return image;
}
