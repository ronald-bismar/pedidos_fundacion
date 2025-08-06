import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';

Widget backgroundScreen(Widget content) {
  return Scaffold(
    body: Container(
      decoration: backgroundDecoration,
      alignment: Alignment.center,
      child: SingleChildScrollView(child: content),
    ),
  );
}
