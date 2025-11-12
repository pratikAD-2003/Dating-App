import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:dating_app/data/repository/place_repo.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository(Utils.mapbox);
});

// final placeSearchProvider =
//     FutureProvider.family<Location?, String>((ref, query) async {
//   final repo = ref.read(placeRepositoryProvider);
//   return repo.searchPlace(query);
// });

final placeSearchProvider =
    FutureProvider.family<List<Location>, String>((ref, query) async {
  final repo = ref.read(placeRepositoryProvider);
  return repo.searchPlaces(query);
});
