import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedidos_fundacion/core/results/result_global.dart';
import 'package:pedidos_fundacion/data/encargado_repository_impl.dart';
import 'package:pedidos_fundacion/domain/entities/encargado.dart';
import 'package:pedidos_fundacion/domain/repositories/encargado_repository.dart';

final registerPhotoPresentationProvider = Provider(
  (ref) => RegisterPhotoPresentationUseCase(ref.watch(coordinatorRepoProvider)),
);

class RegisterPhotoPresentationUseCase {
  final CoordinatorRepository repository;

  RegisterPhotoPresentationUseCase(this.repository);

  Future<Result> call(File? image, Coordinator coordinator) async {
    try {
      if (image == null) {
        return Result.failure('Failed to register photo');
      }

      if (!image.existsSync()) {
        return Result.failure('Image file does not exist');
      }

      final photo = await repository.registerPhoto(image);

      if (photo != null) {
        repository.updatePhotoCoordinator(coordinator, photo);
        return Result.success(photo.id);
      }

      return Result.failure('Failed to register photo');
    } catch (e) {
      return Result.failure('Error registering photo: ${e.toString()}');
    }
  }
}
