import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/progress_indicator.dart';
import 'package:pedidos_fundacion/core/widgets/snackbar.dart';
import 'package:pedidos_fundacion/core/widgets/textfield.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/authentication/presentation/screens/welcome_screen.dart';
import 'package:pedidos_fundacion/features/login/presentation/providers/login_notifier.dart';
import 'package:pedidos_fundacion/features/login/presentation/screens/menu_screen.dart';
import 'package:pedidos_fundacion/features/login/presentation/states/login_state.dart';
import 'package:pedidos_fundacion/presentation/user_application_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        final coordinator = ref.watch(userApplicationProvider);

        if (coordinator != null) {
          log('Is active: ${coordinator.active}');

          bool isActive = coordinator.active;

          if (isActive) {
            cambiarPantallaConNuevaPila(context, MenuScreen());
          } else {
            cambiarPantallaConNuevaPila(context, WelcomeScreen());
          }
        }
      } else if (next is LoginFailure) {
        MySnackBar.error(context, next.error);
      }
    });

    final loginState = ref.watch(loginProvider);

    return backgroundScreen(
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Logo(),
                    SizedBox(height: 20),
                    title('INGRESO'),
                  ],
                ),
                Column(
                  children: [
                    TextFieldCustom(
                      label: "Usuario",
                      controller: usernameController,
                      prefixIcon: Icons.person,
                      textInputType: TextInputType.emailAddress,
                      marginVertical: 8,
                    ),
                    SizedBox(height: 10),
                    TextFieldCustom(
                      label: "Contraseña",
                      controller: passwordController,
                      prefixIcon: Icons.lock,
                      textInputType: TextInputType.visiblePassword,
                      marginVertical: 8,
                    ),
                  ],
                ),

                BotonAncho(
                  text: "Ingresar",
                  onPressed: _handleLogin,
                  marginVertical: 0,
                  marginHorizontal: 0,
                  backgroundColor: white,
                  textColor: dark,
                  paddingHorizontal: 80,
                ),
              ],
            ),
            if (loginState is LoginLoading) const LoadingIndicator(),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    ref
        .read(loginProvider.notifier)
        .loginUser(
          username: usernameController.text,
          password: passwordController.text,
        );
  }
}
