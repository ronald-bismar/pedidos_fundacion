import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

Widget subTitle(String texto, {Color textColor = white}) {
  return Text(
    texto,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
  );
}
