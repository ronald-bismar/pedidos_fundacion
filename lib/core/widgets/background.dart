import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

Widget backgroundScreen(Widget content) {
  Color backgroundColor = primary;
  return Scaffold(
    body: Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: SingleChildScrollView(child: content),
    ),
  );
}
