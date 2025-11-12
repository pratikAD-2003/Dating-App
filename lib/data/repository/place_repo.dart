// import 'dart:convert';
// import 'package:dating_app/data/model/response/auth/profile/preference_res_model.dart';
// import 'package:http/http.dart' as http;

// class PlaceRepository {
//   final String apiKey;

//   PlaceRepository(this.apiKey);

//   Future<Location?> searchPlace(String query) async {
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

//           final coordinates = feature['center'];
//           final double longitude = coordinates[0].toDouble();
//           final double latitude = coordinates[1].toDouble();

//           // Extract city and country
//           String? city;
//           String? country;

//           if (feature['context'] != null) {
//             for (var context in feature['context']) {
//               if (context['id'].toString().startsWith('place.')) {
//                 city = context['text'];
//               } else if (context['id'].toString().startsWith('country.')) {
//                 country = context['text'];
//               }
//             }
//           }

//           // Fallbacks if not found in context
//           city ??= feature['text'];
//           country ??= 'India';

//           return Location(
//             type: "Point",
//             coordinates: [longitude, latitude],
//             city: city,
//             country: country,
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

  Future<List<Location>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json'
      '?types=place,locality,neighborhood,address&access_token=$apiKey&limit=5&country=IN',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List<dynamic>? ?? [];

        return features.map<Location>((feature) {
          final coordinates = feature['center'];
          double longitude = coordinates[0].toDouble();
          double latitude = coordinates[1].toDouble();

          String? city;
          String? area;
          String? country;

          for (var context in feature['context'] ?? []) {
            final id = context['id'].toString();
            if (id.startsWith('place.')) city = context['text'];
            if (id.startsWith('locality.') || id.startsWith('neighborhood.'))
              area = context['text'];
            if (id.startsWith('country.')) country = context['text'];
          }

          city ??= feature['text'];
          country ??= 'India';

          final displayCity = area != null ? "$area, $city" : city;

          return Location(
            type: "Point",
            coordinates: [longitude, latitude],
            city: displayCity,
            country: country,
          );
        }).toList();
      }
    } catch (e) {
      print("❌ Mapbox Exception: $e");
    }
    return [];
  }
}
