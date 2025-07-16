import 'package:flutter/material.dart';

const Color primary = Color(0xFF0894F1);
const Color secondary = Color(0xFF0055FF);
const Color tertiary = Color(0xFF5F82DD);
const Color quaternary = Color(0xFFF2BB05);
const Color white = Color(0xFFFFFFFF);
const Color dark = Color(0xFF212121);

BoxDecoration backgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
);
