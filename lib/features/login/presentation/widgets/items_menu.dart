import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/presentation/screen_factory.dart';

class ItemMenu {
  final String title;
  final IconData icon;
  final ScreenType screenType;
  final Map<String, dynamic>? arguments;

  ItemMenu({
    required this.title,
    required this.icon,
    required this.screenType,
    this.arguments,
  });
}
