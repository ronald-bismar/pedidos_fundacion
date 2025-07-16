import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/constants/grupos.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/alert_dialog_options.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/image_profile_screen.dart';

class LocationPostScreen extends StatelessWidget {
  // final Encargado encargado;
  const LocationPostScreen({
    super.key,
    // required this.encargado
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController lugarController = TextEditingController();
    return backgroundScreen(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Logo(),
            title('COMPLETE EL REGISTRO'),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  TextFieldCustom(
                    label: "Lugar",
                    controller: lugarController,
                    prefixIcon: Icons.location_on,
                    textInputType: TextInputType.emailAddress,
                    marginVertical: 8,
                  ),
                  // if (encargado.cargo == Cargo.tutor) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: AlertDialogOptions(
                      titleAlertDialog: 'Programa/Grupo',
                      widthAlertDialog: double.infinity,
                      itemInitial: '',
                      onSelect: (cargo) => {},
                      items: Grupo.values,
                      icon: Icons.group,
                      messageInfo: 'Programa/Grupo',
                    ),
                  ),
                  // ],
                ],
              ),
            ),

            BotonAncho(
              text: "Registrar",
              onPressed: () async {
                cambiarPantalla(context, ImageProfileScreen());
              },
              marginVertical: 0,
              backgroundColor: white,
              textColor: dark,
              paddingHorizontal: 60,
            ),
          ],
        ),
      ),
    );
  }
}