import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/image_user_profile.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/item_menu_card.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/items_menu.dart';
import 'package:pedidos_fundacion/presentation/screen_factory.dart';
import 'package:pedidos_fundacion/toDataDynamic/items_menu.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});
  final ScreenFactory screenFactory = ScreenFactory();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primary,
        alignment: Alignment.center,
        child: SingleChildScrollView(child: contentMenu(context, menuItems)),
      ),
      drawer: drawerMenu(context),
    );
  }

  Drawer drawerMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Logo(widthLogo: 100, heightLogo: 50),
                SizedBox(height: 10),
                Text(
                  'Bienvenido',
                  style: TextStyle(color: white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: dark),
            title: Text('Cerrar sesión', style: TextStyle(color: dark)),
            onTap: () {
              Navigator.pop(context);
              // Add logout functionality here
            },
          ),
        ],
      ),
    );
  }

  Container contentMenu(BuildContext context, List<ItemMenu> listItems) {
    return Container(
      padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Logo(widthLogo: 140, heightLogo: 70),
              ImageUserProfile(),
            ],
          ),
          title('MENU PRINCIPAL'),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: listItems.length,
              itemBuilder: (context, index) {
                return itemMenu(
                  listItems[index],
                  index,
                  () => _navigateToScreen(context, listItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para navegar usando el factory
  void _navigateToScreen(BuildContext context, ItemMenu menuItem) {
    log('Ejecutando navigate to screen');
    try {
      final screen = screenFactory.createScreen(
        menuItem.screenType,
        arguments: menuItem.arguments,
      );
      cambiarPantalla(context, screen);
    } catch (e) {
      // Manejo de errores
      log('Error al navegar: $e');
    }
  }
}
