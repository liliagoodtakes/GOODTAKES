import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceIndex {
  final String placeId;
  final LatLng latLng;
  final List<String> type;
  final String district;

  const PlaceIndex._(
      {required this.latLng,
      required this.placeId,
      required this.type,
      required this.district});

  factory PlaceIndex.build(Map index, String pid) {
    return PlaceIndex._(
        latLng: LatLng.fromJson(index["geo"]) ?? const LatLng(0, 0),
        placeId: pid,
        type: (index["type"] as List?)?.cast<String>() ?? <String>[],
        district: index["district"] ?? "");
  }
}
