// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../places/domain/entities/place_entity.dart';
// import '../../groups/domain/entities/group_entity.dart';
// import '../../places/data/datasources/place_remote_datasource.dart';
// import '../../groups/data/datasources/group_remote_datasource.dart'; // ✅ Ruta de importación corregida

// // Providers de la capa de datos
// final placeRemoteDataSourceProvider =
//     Provider((ref) => PlaceRemoteDataSource());
// final groupRemoteDataSourceProvider =
//     Provider((ref) => GroupRemoteDataSource());

// // Providers para acceder a la lista de entidades
// final placesStreamProvider = StreamProvider<List<PlaceEntity>>((ref) {
//   final remoteDataSource = ref.read(placeRemoteDataSourceProvider);
//   return remoteDataSource.getPlaces();
// });

// final groupsStreamProvider = StreamProvider<List<GroupEntity>>((ref) {
//   final remoteDataSource = ref.read(groupRemoteDataSourceProvider);
//   return remoteDataSource.getGroups();
// });