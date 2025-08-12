import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

Widget textNormal(
  String texto, {
  Color textColor = white,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return Text(
    texto,
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 14, fontWeight: fontWeight, color: textColor),
  );
}
