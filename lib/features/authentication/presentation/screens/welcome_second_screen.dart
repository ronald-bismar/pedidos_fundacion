import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/login/presentation/screens/login_screen.dart';

class WelcomeSecondScreen extends StatelessWidget {
  const WelcomeSecondScreen({super.key});

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: title(
                'Programa de desarrollo integral de niños y jovenes en situación de vulnerabilidad',
                textColor: dark,
              ),
            ),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/child.png',
                height: 300,
                width: 350,
                fit: BoxFit.cover,
              ),
            ),

            BotonAncho(
              text: "Empezar",
              onPressed: () async {
                cambiarPantalla(context, LoginScreen());
              },
              marginVertical: 0,
              marginHorizontal: 0,
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
