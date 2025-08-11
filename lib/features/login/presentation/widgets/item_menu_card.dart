import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/items_menu.dart';

Card itemMenu(ItemMenu item, int index, VoidCallback navigateScreen) {
  return Card(
    color: white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: navigateScreen,
      borderRadius: BorderRadius.circular(12), // Coincide con el Card
      splashColor: primary.withOpacity(0.1), // Efecto ripple
      highlightColor: primary.withOpacity(0.05), // Al mantener presionado
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Icon(item.icon, color: secondary, size: 60)),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(color: dark, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
