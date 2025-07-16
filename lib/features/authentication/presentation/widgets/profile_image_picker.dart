import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedidos_fundacion/core/services/image_picker.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function(File?) onImageSelected;
  const ProfileImagePicker({super.key, required this.onImageSelected});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? imageSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [imagePicker(), buttonPicker()]);
  }

  Positioned buttonPicker() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: IconButton(
          icon: const Icon(Icons.edit, color: white, size: 30),
          onPressed: () {
            showModalOptions();
          },
        ),
      ),
    );
  }

  void showModalOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                title('Seleccionar Imagen', textColor: dark),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Subir desde Galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _selectImage();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Tomar Fotografía'),
                  onTap: () {
                    Navigator.pop(context);
                    _openCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Card imagePicker() {
    return Card(
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      child: GestureDetector(
        onTap: () {
          showModalOptions();
        },
        child: Container(
          padding: const EdgeInsets.all(4.0),
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(55.0),
            gradient: LinearGradient(
              colors: [
                white.withOpacity(0.9).withAlpha(100),
                secondary.withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: imageSelected != null
                ? Image.file(imageSelected!, fit: BoxFit.cover)
                : Image.asset('assets/hombre.png', fit: BoxFit.none),
          ),
        ),
      ),
    );
  }

  void _selectImage() async {
    final XFile? image = await getImageFromGallery();
    updateState(image);
  }

  void updateState(XFile? image) {
    if (image != null) {
      setState(() {
        File imageFile = File(image.path);
        imageSelected = imageFile;
        widget.onImageSelected(imageFile);
      });
    } else {
      widget.onImageSelected(null);
    }
  }

  void _openCamera() async {
    final XFile? image = await getImageFromCamera();
    updateState(image);
  }
}
