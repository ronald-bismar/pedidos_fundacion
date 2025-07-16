import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

Widget textNormal(String texto, {Color textColor = white}) {
  return Text(
    texto,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textColor,
    ),
  );
}
