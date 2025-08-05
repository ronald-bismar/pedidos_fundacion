import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/theme/colors.dart';
import 'package:pedidos_fundacion/features/login/presentation/providers/image_user_profile_provider.dart';
import 'package:pedidos_fundacion/presentation/user_application_provider.dart';

class ImageUserProfile extends ConsumerStatefulWidget {
  const ImageUserProfile({super.key});

  @override
  ConsumerState<ImageUserProfile> createState() => _ImageUserProfileState();
}

class _ImageUserProfileState extends ConsumerState<ImageUserProfile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final coordinator = ref.read(userApplicationProvider);
      if (coordinator != null) {
        ref
            .read(imageUserProfileProvider.notifier)
            .loadNameAndPhoto(coordinator);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(imageUserProfileProvider);
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(55.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55.0),
              gradient: LinearGradient(
                colors: [
                  white.withOpacity(0.9).withAlpha(100),
                  secondary.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: userProfile == null
                  ? Image.asset('assets/hombre.png', fit: BoxFit.cover)
                  : userProfile.isLocal
                  ? Image.file(
                      File(userProfile.urlPhoto ?? ''),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      userProfile.urlPhoto ?? '',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Text(userProfile?.name ?? '', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
