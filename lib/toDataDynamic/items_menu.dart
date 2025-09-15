import 'package:flutter/material.dart';
import 'package:pedidos_fundacion/features/login/presentation/widgets/items_menu.dart';
import 'package:pedidos_fundacion/presentation/screen_factory.dart';


final menuItems = [
  ItemMenu(
    title: 'Pedidos', 
    icon: Icons.list, 
    screenType: ScreenType.pedidos
  ),
   ItemMenu(
    title: 'Lista de Pedidos', 
    icon: Icons.list, 
    screenType: ScreenType.listaPedidos
  ),

  ItemMenu(
    title: 'Lista Pedidos Supervisor',
    icon: Icons.list,
    screenType: ScreenType.supervisorPedidos, 
  ),
  ItemMenu(
    title: 'Mis Pedidos Tutor',
    icon: Icons.person,
    screenType: ScreenType.tutorPedidos,
  ),
  ItemMenu(
    title: 'Entregas',
    icon: Icons.delivery_dining,
    screenType: ScreenType.entregas,
  ),
  ItemMenu(
    title: 'Beneficiarios',
    icon: Icons.group,
    screenType: ScreenType.beneficiarios,
  ),
  ItemMenu(
    title: 'Asistencia Beneficiarios',
    icon: Icons.group_add,
    screenType: ScreenType.asistenciaBeneficiarios,
  ),
  ItemMenu(
    title: 'Personal',
    icon: Icons.person,
    screenType: ScreenType.personal,
  ),
  ItemMenu(
    title: 'Reportes',
    icon: Icons.report,
    screenType: ScreenType.reportes,
  ),
  ItemMenu(
    title: 'Lugares', 
    icon: Icons.place, 
    screenType: ScreenType.lugares
  ),
  ItemMenu(
    title: 'Grupos', 
    icon: Icons.group, 
    screenType: ScreenType.grupos
  ),
];