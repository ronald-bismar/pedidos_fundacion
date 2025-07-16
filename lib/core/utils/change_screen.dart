import 'package:flutter/material.dart';

void cambiarPantallaConNuevaPila(BuildContext context, Widget newScreen) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => newScreen),
  );
}

void cambiarPantalla(BuildContext context, Widget newScreen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => newScreen),
  );
}

void volverAnteriorPantalla(BuildContext context) {
  Navigator.pop(
    context,
  );
}
