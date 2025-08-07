import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/items_menu.dart';

GestureDetector itemMenu(ItemMenu item, int index, Function navigateScreen) {
  return GestureDetector(
    onTap: () => navigateScreen(),
    child: Card(
      color: white,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Icon(item.icon, color: secondary, size: 60)),
            SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(color: dark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
