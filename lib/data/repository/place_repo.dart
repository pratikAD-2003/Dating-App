// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:dating_app/data/model/place_model.dart';

// class PlaceRepository {
//   final String apiKey;

//   PlaceRepository(this.apiKey);

//   Future<PlaceModel?> searchPlace(String query) async {
//     if (query.trim().isEmpty) return null;

//     final url = Uri.parse(
//       'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json'
//       '?types=place&access_token=$apiKey&limit=1&country=IN',
//     );

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data['features'] != null && data['features'].isNotEmpty) {
//           final feature = data['features'][0];

//           final placeName = feature['place_name'] ?? '';
//           final text = feature['text'] ?? '';
//           final coordinates = feature['center'];
//           final double longitude = coordinates[0].toDouble();
//           final double latitude = coordinates[1].toDouble();

//           return PlaceModel(
//             type: "place",
//             text: text,
//             placeName: placeName,
//             latitude: latitude,
//             longitude: longitude,
//           );
//         }
//       } else {
//         print("❌ Mapbox HTTP Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//     }

//     return null;
//   }
// }

import 'dart:convert';
import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
import 'package:http/http.dart' as http;

class PlaceRepository {
  final String apiKey;

  PlaceRepository(this.apiKey);

  Future<Location?> searchPlace(String query) async {
    if (query.trim().isEmpty) return null;

    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json'
      '?types=place&access_token=$apiKey&limit=1&country=IN',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['features'] != null && data['features'].isNotEmpty) {
          final feature = data['features'][0];

          final coordinates = feature['center'];
          final double longitude = coordinates[0].toDouble();
          final double latitude = coordinates[1].toDouble();

          // Extract city and country
          String? city;
          String? country;

          if (feature['context'] != null) {
            for (var context in feature['context']) {
              if (context['id'].toString().startsWith('place.')) {
                city = context['text'];
              } else if (context['id'].toString().startsWith('country.')) {
                country = context['text'];
              }
            }
          }

          // Fallbacks if not found in context
          city ??= feature['text'];
          country ??= 'India';

          return Location(
            type: "Point",
            coordinates: [longitude, latitude],
            city: city,
            country: country,
          );
        }
      } else {
        print("❌ Mapbox HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }

    return null;
  }
}
