import 'package:flutter/material.dart';

Color primary = const Color(0xFF0894F1);
Color secondary = const Color(0xFF0055FF);
Color tertiary = const Color(0xFF5f82dd);
Color quaternary = const Color.fromARGB(255, 242, 187, 5);
Color white = const Color(0xFFF2F2F2);

BoxDecoration backgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
);
