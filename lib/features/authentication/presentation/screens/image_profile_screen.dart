import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/text_button_custom.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/generate_user_password_screen.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/widgets/profile_image_picker.dart';

class ImageProfileScreen extends StatefulWidget {
  // final Encargado encargado;
  const ImageProfileScreen({
    super.key,
    // required this.encargado
  });

  @override
  State<ImageProfileScreen> createState() => _ImageProfileScreenState();
}

class _ImageProfileScreenState extends State<ImageProfileScreen> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return backgroundScreen(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Logo(),
            title('Foto de Presentación'),
            ProfileImagePicker(
              onImageSelected: (File? image) {
                _selectedImage = image;
              },
            ),

            Column(
              children: [
                BotonAncho(
                  text: "Registrar",
                  onPressed: () async {
                    cambiarPantalla(context, GenerateUserPasswordScreen());
                  },
                  marginVertical: 0,
                  backgroundColor: white,
                  textColor: dark,
                  paddingHorizontal: 60,
                ),
                TextButtonCustom(
                  text: "Omitir",
                  onPressed: () => {
                    cambiarPantalla(context, GenerateUserPasswordScreen()),
                  },
                  marginVertical: 0,
                  textColor: dark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
