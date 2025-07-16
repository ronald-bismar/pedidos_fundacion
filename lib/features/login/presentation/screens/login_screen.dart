import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/login/presentation/screens/menu_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usuarioController = TextEditingController();
    final TextEditingController contrasenaController = TextEditingController();

    return backgroundScreen(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [const Logo(), SizedBox(height: 20), title('INGRESO')],
            ),
            Column(
              children: [
                TextFieldCustom(
                  label: "Usuario",
                  controller: usuarioController,
                  prefixIcon: Icons.person,
                  textInputType: TextInputType.emailAddress,
                  marginVertical: 8,
                ),
                SizedBox(height: 10),
                TextFieldCustom(
                  label: "Contraseña",
                  controller: contrasenaController,
                  prefixIcon: Icons.lock,
                  textInputType: TextInputType.visiblePassword,
                  marginVertical: 8,
                ),
              ],
            ),

            BotonAncho(
              text: "Ingresar",
              onPressed: () async {
                cambiarPantalla(context, MenuScreen());
              },
              marginVertical: 0,
              marginHorizontal: 0,
              backgroundColor: white,
              textColor: dark,
              paddingHorizontal: 80,
            ),
          ],
        ),
      ),
    );
  }
}
