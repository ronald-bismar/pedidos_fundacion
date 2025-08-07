import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/text_button_custom.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/providers/register_photo_notifier.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/states/register_photo_state.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/widgets/profile_image_picker.dart';

class ImageProfileBeneficiaryScreen extends ConsumerStatefulWidget {
  // final Coordinator coordinator;
  const ImageProfileBeneficiaryScreen({super.key});

  @override
  ConsumerState<ImageProfileBeneficiaryScreen> createState() =>
      _ImageProfileBeneficiaryScreenState();
}

class _ImageProfileBeneficiaryScreenState
    extends ConsumerState<ImageProfileBeneficiaryScreen> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterPhotoState>(registerPhotoProvider, (previous, next) {
      if (next is RegisterSuccess) {
        // cambiarPantalla(
        //   context,
        //   GenerateUserPasswordScreen(coordinatorId: widget.coordinator.id),
        // );
      } else if (next is RegisterFailure) {
        MySnackBar.error(context, next.error);
      }
    });

    final registerPhotoState = ref.watch(registerPhotoProvider);

    return backgroundScreen(
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
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
                      onPressed: () async => _handleRegister(),
                      marginVertical: 0,
                      backgroundColor: white,
                      textColor: dark,
                      paddingHorizontal: 60,
                    ),
                    TextButtonCustom(
                      text: "Omitir",
                      onPressed: () => {
                        // cambiarPantalla(
                        //   context,
                        // BeneficiariesScreen()
                        // GenerateUserPasswordScreen(
                        //   coordinatorId: widget.coordinator.id,
                        // ),
                        // ),
                      },
                      marginVertical: 0,
                      textColor: dark,
                    ),
                  ],
                ),
              ],
            ),
            if (registerPhotoState is RegisterLoading) const LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  void _handleRegister() {
    // ref
    //     .read(registerPhotoProvider.notifier)
    //     .registerPhoto(photo: _selectedImage, coordinator: widget.coordinator);
  }
}
