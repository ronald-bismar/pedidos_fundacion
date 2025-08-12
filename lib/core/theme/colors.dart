import 'package:flutter/material.dart';

const Color primary = Color(0xFF0894F1);
const Color secondary = Color(0xFF0055FF);
const Color tertiary = Color(0xFF5F82DD);
const Color quaternary = Color(0xFFF9AA00);
const Color white = Color(0xFFF8F8F8);
const Color dark = Color(0xFF212121);

BoxDecoration backgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [primary, secondary.withOpacity(0.8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.6, 1.0],
  ),
);
