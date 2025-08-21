import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

Widget subTitle(
  String texto, {
  Color textColor = white,
  FontWeight fontWeight = FontWeight.w500,
  TextAlign textAlign = TextAlign.center,
}) {
  return Text(
    texto,
    textAlign: textAlign,
    style: TextStyle(fontSize: 18, fontWeight: fontWeight, color: textColor),
  );
}
