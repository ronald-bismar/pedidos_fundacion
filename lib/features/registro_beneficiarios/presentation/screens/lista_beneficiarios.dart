import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/item_menu_card.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/items_menu.dart';
import 'package:pedidos_fundacion/toDataDynamic/items_menu.dart';

class ListBeneficiariesScreen extends ConsumerStatefulWidget {
  final String beneficiaryId;
  const ListBeneficiariesScreen({this.beneficiaryId = '', super.key});

  @override
  ConsumerState<ListBeneficiariesScreen> createState() =>
      _ListaBeneficiariesScreenState();
}

class _ListaBeneficiariesScreenState
    extends ConsumerState<ListBeneficiariesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primary,
        alignment: Alignment.center,
        child: SingleChildScrollView(child: contentMenu(context, menuItems)),
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
          title('MENU PRINCIPAL'),
          Expanded(
            child: ListView.builder(
              // Removido el gridDelegate para hacer una lista normal
              itemCount: listItems.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                  ), // Espaciado entre items
                  child: itemMenu(listItems[index], index, () => {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
