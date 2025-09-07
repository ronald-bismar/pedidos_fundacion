import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/core/widgets/boton_normal.dart';
import 'package:pedidos_fundacion/core/widgets/subtitle.dart';
import 'package:pedidos_fundacion/core/widgets/text_normal.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/beneficio.dart';
import 'package:pedidos_fundacion/features/entregas/domain/entities/entrega_beneficiario.dart';
import 'package:pedidos_fundacion/features/entregas/presentation/providers/benefits_provider.dart';

class RegisterDeliveryBeneficiaryScreen extends ConsumerStatefulWidget {
  final DeliveryBeneficiary deliveryBeneficiary;

  const RegisterDeliveryBeneficiaryScreen({
    super.key,
    required this.deliveryBeneficiary,
  });

  @override
  ConsumerState<RegisterDeliveryBeneficiaryScreen> createState() =>
      _RegisterDeliveryBeneficiaryScreenState();
}

class _RegisterDeliveryBeneficiaryScreenState
    extends ConsumerState<RegisterDeliveryBeneficiaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();
  final Map<String, bool> _productStates = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error al tomar la foto: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _registerDelivery() async {
    if (_capturedImage == null) {
      _showErrorSnackBar('Por favor, tome una foto antes de registrar');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular guardado de imagen y registro
      await Future.delayed(const Duration(seconds: 2));

      final updatedDelivery = widget.deliveryBeneficiary.copyWith(
        state: 'Entregado',
        deliveryDate: DateTime.now(),
        idPhotoDelivery: 'photo_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Aquí irían las llamadas a tu API para:
      // 1. Subir la imagen
      // 2. Actualizar el DeliveryBeneficiary
      // 3. Crear/actualizar los ProductBeneficiary

      _showSuccessSnackBar('Entrega registrada exitosamente');

      // Navegar hacia atrás con un delay para mostrar el mensaje
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pop(updatedDelivery);
    } catch (e) {
      _showErrorSnackBar('Error al registrar la entrega: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final benefitsAsync = ref.watch(
      benefitsProvider(widget.deliveryBeneficiary.idDelivery),
    );
    final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: subTitle(
          'Detalle de la entrega',
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Tarjeta principal expandida
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información de la entrega (contenido fijo)
                          _buildDeliveryInfo(formattedDate),

                          const SizedBox(height: 24),

                          // Sección de cámara (contenido fijo)
                          _buildCameraSection(),

                          const SizedBox(height: 24),

                          // Lista de productos expandible
                          Expanded(
                            child: benefitsAsync.when(
                              loading: () => _buildLoadingProducts(),
                              error: (error, _) => _buildErrorProducts(),
                              data: (benefits) => _buildProductsList(benefits),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Botón de registro fijo en la parte inferior
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: _buildRegisterButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textNormal(
          'Fecha de entrega $formattedDate',
          textColor: Colors.grey[600]!,
        ),
        const SizedBox(height: 8),
        textNormal(
          'Programa: Triunfadores I',
          textColor: primary,
          fontWeight: FontWeight.w600,
        ),
        textNormal(
          'BO0345456647',
          textColor: primary,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8),
        textNormal(
          widget.deliveryBeneficiary.nameBeneficiary,
          textColor: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildCameraSection() {
    return Expanded(
      child: GestureDetector(
        onTap: _takePicture,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: _capturedImage != null
                ? Colors.transparent
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: _capturedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_capturedImage!, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    textNormal('Tomar foto', textColor: Colors.grey[600]!),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingProducts() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorProducts() {
    return Center(
      child: textNormal('Error al cargar productos', textColor: Colors.red),
    );
  }

  Widget _buildProductsList(List<Benefit> benefits) {
    // Inicializar estados si no existen
    for (var benefit in benefits) {
      _productStates[benefit.id] ??= false;
    }

    if (benefits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            textNormal(
              'No hay productos registrados',
              textColor: Colors.grey[600]!,
            ),
          ],
        ),
      );
    }

    return ListView(
      children: benefits.map((benefit) => _buildProductItem(benefit)).toList(),
    );
  }

  Widget _buildProductItem(Benefit benefit) {
    final isChecked = _productStates[benefit.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: textNormal(benefit.description, textColor: Colors.black87),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _productStates[benefit.id] = !isChecked;
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isChecked ? Colors.green : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
                color: isChecked ? Colors.green : Colors.transparent,
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: BotonNormal(
        onPressed: _registerDelivery,
        label: _isLoading ? 'Registrando...' : 'Registrar entrega',
        textColor: Colors.white,
        buttonColor: _isLoading ? Colors.grey : secondary,
      ),
    );
  }
}
