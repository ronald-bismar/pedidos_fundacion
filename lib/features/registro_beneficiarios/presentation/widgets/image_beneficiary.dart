import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/features/registro_beneficiarios/presentation/providers/image_beneficiary_provider.dart';

class ImageBeneficiary extends ConsumerWidget {
  final String idPhotoBeneficiary;
  const ImageBeneficiary(this.idPhotoBeneficiary, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageProfile = ref.watch(
      imageBeneficiaryProvider(idPhotoBeneficiary),
    );
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(55.0),
          gradient: LinearGradient(
            colors: [primary.withOpacity(0.1), secondary.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: imageProfile.urlPhoto == null
              ? Image.asset('assets/hombre.png', fit: BoxFit.cover)
              : imageProfile.isLocal
              ? Image.file(File(imageProfile.urlPhoto ?? ''), fit: BoxFit.cover)
              : Image.network(imageProfile.urlPhoto ?? '', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
