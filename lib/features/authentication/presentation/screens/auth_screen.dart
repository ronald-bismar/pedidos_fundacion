import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/constants/cargos.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/alert_dialog_options.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/location_post_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cedulaController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController apellidoController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController profesionController = TextEditingController();
    return backgroundScreen(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Logo(),
            title('REGISTRO DE USUARIO'),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  TextFieldCustom(
                    label: "Cedula de identidad",
                    controller: cedulaController,
                    marginVertical: 8,
                    prefixIcon: Icons.badge,
                  ),
                  TextFieldCustom(
                    label: "Nombre",
                    controller: nombreController,
                    marginVertical: 8,
                    prefixIcon: Icons.person,
                    textInputType: TextInputType.name,
                  ),
                  TextFieldCustom(
                    label: "Apellidos",
                    controller: apellidoController,
                    prefixIcon: Icons.person_2_outlined,
                    textInputType: TextInputType.name,
                    marginVertical: 8,
                  ),
                  TextFieldCustom(
                    label: "Email",
                    controller: emailController,
                    prefixIcon: Icons.email,
                    textInputType: TextInputType.emailAddress,
                    marginVertical: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: AlertDialogOptions(
                      titleAlertDialog: 'Cargo',
                      widthAlertDialog: double.infinity,
                      itemInitial: '',
                      onSelect: (cargo) => {},
                      items: Cargo.values,
                      icon: Icons.admin_panel_settings,
                      messageInfo: 'Cargo',
                    ),
                  ),
                  TextFieldCustom(
                    label: "Profesión",
                    controller: profesionController,
                    prefixIcon: Icons.work,
                    textCapitalization: TextCapitalization.words,
                    textInputType: TextInputType.text,
                    marginVertical: 8,
                  ),
                ],
              ),
            ),

            BotonAncho(
              text: "Siguiente",
              onPressed: () async {
                cambiarPantalla(context, LocationPostScreen());
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
