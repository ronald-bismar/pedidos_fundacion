import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/utils/change_screen.dart';
import 'package:pedidos_fundacion/core/utils/uuid.dart';
import 'package:pedidos_fundacion/core/widgets/background.dart';
import 'package:pedidos_fundacion/core/widgets/boton_ancho.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/title.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/screens/seleccionar_grupos_screen.dart';

class AddBenefitsFinancialAidScreen extends ConsumerStatefulWidget {
  final String nameDelivery;
  final DateTime dateDelivery;
  const AddBenefitsFinancialAidScreen(
    this.nameDelivery,
    this.dateDelivery, {
    super.key,
  });

  @override
  ConsumerState<AddBenefitsFinancialAidScreen> createState() =>
      _AddBenefitsFinancialAidScreenState();
}

class _AddBenefitsFinancialAidScreenState
    extends ConsumerState<AddBenefitsFinancialAidScreen> {
  List<Benefit> benefits = [];
  final TextEditingController _newProductController = TextEditingController();
  bool _showAddField = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _newProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return backgroundScreen(
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    title('Ingrese los productos o efectivo que se entregará'),
                    const SizedBox(height: 20),
                    Expanded(child: _buildProductsList()),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: BotonAncho(
                      text: "Siguiente",
                      onPressed: _nextStep,
                      marginVertical: 0,
                      marginHorizontal: 0,
                      backgroundColor: secondary,
                      textColor: white,
                      paddingHorizontal: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      itemCount:
          benefits.length +
          (_showAddField ? 1 : 0) +
          1, // +1 para el botón "Agregar Producto"
      itemBuilder: (context, index) {
        // Productos existentes
        if (index < benefits.length) {
          return _buildProductCard(benefits[index], index);
        }

        // Campo para agregar nuevo producto
        if (_showAddField && index == benefits.length) {
          return _buildAddProductField();
        }

        // Botón "Agregar Producto" al final
        return _buildAddProductButton();
      },
    );
  }

  Widget _buildProductCard(Benefit benefit, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: subTitle(
                benefit.description,
                fontWeight: FontWeight.w500,
                textColor: dark,
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () => _editProduct(index),
                ),
                // Botón de eliminar
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeProduct(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newProductController,
                decoration: const InputDecoration(
                  hintText: "Nombre del producto",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 16),
                autofocus: true,
                onSubmitted: (_) => _addProduct(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: _addProduct,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProductButton() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 80,
      ), // Espacio para el botón inferior
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: _showAddProductField,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "Agregar Producto",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProductField() {
    setState(() {
      _showAddField = true;
    });
  }

  void _addProduct() {
    if (_newProductController.text.trim().isEmpty) return;

    setState(() {
      benefits.add(
        Benefit(
          id: UUID.generateUUID(),
          description: _newProductController.text.trim(),
        ),
      );
      _newProductController.clear();
      _showAddField = false;
    });
  }

  void _removeProduct(int index) {
    setState(() {
      benefits.removeAt(index);
    });
  }

  void _editProduct(int index) {
    final benefit = benefits[index];
    final controller = TextEditingController(text: benefit.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Producto"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nombre del producto"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  benefits[index] = Benefit(
                    id: benefit.id,
                    description: controller.text.trim(),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
 
  void _nextStep() {
    if (benefits.isEmpty) return;

    cambiarPantalla(
      context,
      SelectGroupsByDeliveryScreen(widget.nameDelivery, widget.dateDelivery),
    );
  }
}
