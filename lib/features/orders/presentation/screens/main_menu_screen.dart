import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'group_registration_screen.dart';
import 'place_registration_screen.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.menu_book, color: Colors.white, size: 30);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Información de la aplicación.')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 18.0,
            mainAxisSpacing: 18.0,
            children: [
              // _buildMenuItem(
              //   context,
              //   icon: Icons.assignment_ind,
              //   title: 'Mis Pedidos (Tutor)',
              //   description: 'Crea y gestiona tus solicitudes.',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const OrderListScreen()),
              //     );
              //   },
              //   color: Colors.lightBlue.shade700,
              // ),
              // _buildMenuItem(
              //   context,
              //   icon: Icons.supervised_user_circle,
              //   title: 'Pedidos (Supervisor)',
              //   description: 'Supervisa los pedidos de todos los tutores.',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const SupervisorOrderListScreen()),
              //     );
              //   },
              //   color: Colors.deepPurple.shade700,
              // ),
              // Nuevo botón para el registro de pedidos
              // _buildMenuItem(
              //   context,
              //   icon: Icons.add_shopping_cart, // Icono sugerido para crear un pedido
              //   title: 'Registrar Pedido',
              //   description: 'Inicia una nueva solicitud de pedido.',
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
              //     );
              //   },
              //   color: Colors.orange.shade700, 
              // ),
              _buildMenuItem(
                context,
                icon: Icons.delivery_dining,
                title: 'Entregas',
                description: 'Administra las entregas de pedidos.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Módulo de Entregas (próximamente)'),
                      backgroundColor: Colors.orange.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                color: Colors.green.shade700,
              ),
              _buildMenuItem(
                context,
                icon: Icons.history,
                title: 'Historial de Entregas',
                description: 'Revisa entregas pasadas y su estado.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Módulo de Historial de Entregas (próximamente)'),
                      backgroundColor: Colors.orange.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                color: Colors.grey.shade700,
              ),
              _buildMenuItem(
                context,
                icon: Icons.group_add,
                title: 'Personal',
                description: 'Gestiona la información del equipo.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Módulo de Personal (próximamente)'),
                      backgroundColor: Colors.orange.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                color: Colors.purple.shade700,
              ),
              _buildMenuItem(
                context,
                icon: Icons.people,
                title: 'Beneficiados',
                description: 'Administra la lista de beneficiarios.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Módulo de Beneficiados (próximamente)'),
                      backgroundColor: Colors.orange.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                color: Colors.teal.shade700,
              ),
              _buildMenuItem(
                context,
                icon: Icons.bar_chart,
                title: 'Reportes',
                description: 'Visualiza estadísticas y análisis.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Módulo de Reportes (próximamente)'),
                      backgroundColor: Colors.orange.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                color: Colors.deepOrange.shade700,
              ),
              _buildMenuItem(
                context,
                icon: Icons.people_outline,
                title: 'Reg. Programas/Grupos',
                description: 'Registra y edita programas o grupos de apoyo.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GroupRegistrationScreen()),
                  );
                },
                color: Colors.indigo.shade700,
              ),
              _buildMenuItem(
                context,
                icon: Icons.location_on_outlined,
                title: 'Reg. Lugares',
                description: 'Define y gestiona las ubicaciones de entrega.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PlaceRegistrationScreen()),
                  );
                },
                color: Colors.brown.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? description,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 55, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}