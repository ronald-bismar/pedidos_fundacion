import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/welcome_screen.dart';

class GenerateUserPasswordScreen extends StatelessWidget {
  const GenerateUserPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usuarioController = TextEditingController(
      text: 'Usuario generado',
    );
    final TextEditingController contrasenaController = TextEditingController(
      text: 'Contraseña generada',
    );

    return backgroundScreen(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Logo(),
            Column(
              children: [
                title('USUARIO Y CONTRASEÑA'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: subTitle(
                    'Usuario y contraseña para el acceso a la aplicación',
                    textColor: dark,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  TextFieldCustom(
                    label: "Usuario generado",
                    controller: usuarioController,
                    prefixIcon: Icons.person,
                    textInputType: TextInputType.emailAddress,
                    marginVertical: 8,
                    readOnly: true,
                  ),
                  TextFieldCustom(
                    label: "Contraseña generada",
                    controller: contrasenaController,
                    prefixIcon: Icons.lock,
                    textInputType: TextInputType.visiblePassword,
                    marginVertical: 8,
                    readOnly: true,
                  ),
                ],
              ),
            ),

            textNormal(
              "Se enviará un correo electrónico de confirmación al usuario con los datos de acceso.",
              textColor: dark,
            ),

            BotonAncho(
              text: "Enviar email de confirmación",
              onPressed: () async {
                cambiarPantalla(context, WelcomeScreen());
              },
              marginVertical: 0,
              marginHorizontal: 0,
              backgroundColor: secondary,
              textColor: white,
              paddingHorizontal: 20,
            ),
          ],
        ),
      ),
    );
  }
}
