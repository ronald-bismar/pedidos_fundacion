import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/logo.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/item_menu_card.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/items_menu.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listItems = [
      ItemMenu(title: 'Pedidos', icon: Icons.list),
      ItemMenu(title: 'Entregas', icon: Icons.delivery_dining),
      ItemMenu(title: 'Historial de Entregas', icon: Icons.history),
      ItemMenu(title: 'Personal', icon: Icons.person),
      ItemMenu(title: 'Beneficiarios', icon: Icons.group),
      ItemMenu(title: 'Reportes', icon: Icons.report),
    ];
    return Scaffold(
      body: Container(
        color: primary,
        alignment: Alignment.center,
        child: SingleChildScrollView(child: contentMenu(context, listItems)),
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
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Logo(widthLogo: 180, heightLogo: 70),
          SizedBox(height: 10),
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
                return itemMenu(listItems[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
