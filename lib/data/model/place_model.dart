import 'package:mapbox_search/models/predictions.dart';

class PlaceModel {
  final String type;
  final String text;
  final String placeName;
  final double latitude;
  final double longitude;

  PlaceModel({
    required this.type,
    required this.text,
    required this.placeName,
    required this.latitude,
    required this.longitude,
  });

  // ✅ Factory for creating from Mapbox response
  factory PlaceModel.fromMapBox(MapBoxPlace place) {
    final coords = place.geometry?.coordinates;

    return PlaceModel(
      type: place.type?.toString() ?? "place",
      text: place.text ?? "",
      placeName: place.placeName ?? "",
      latitude: coords?.lat ?? 0.0,
      longitude: coords?.long ?? 0.0,
    );
  }

  // ✅ To JSON
  Map<String, dynamic> toJson() => {
    "type": type,
    "text": text,
    "placeName": placeName,
    "center": {
      "coordinates": [longitude, latitude],
      "type": "Point",
    },
  };
}
