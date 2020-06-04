// Geocodeing API
// https://developers.google.com/maps/documentation/geocoding/intro#GeocodingRequests
class GeoCodeResponse {
  final List<GeometryEntity> geometries;

  GeoCodeResponse(this.geometries);

  static const _resultsKey = 'results';

  factory GeoCodeResponse.fromJson(Map<String, dynamic> json) {
    final results = json[_resultsKey] as List<Object>;
    final geometryList = results
        .map(
            (result) => GeometryEntity.fromJson(result as Map<String, dynamic>))
        .toList();
    return GeoCodeResponse(geometryList);
  }
}

class GeometryEntity {
  final LocationEntity location;

  GeometryEntity(this.location);

  static const _geometryKey = 'geometry';

  factory GeometryEntity.fromJson(Map<String, dynamic> json) {
    final geometryJson = json[_geometryKey] as Map<String, dynamic>;
    return GeometryEntity(LocationEntity.fromJson(geometryJson));
  }
}

class LocationEntity {
  final double latitude;
  final double longitude;

  LocationEntity(this.latitude, this.longitude);

  static const _locationKey = 'location';
  static const _latitudeKey = 'lat';
  static const _longitudeKey = 'lng';

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    final latitude = json[_locationKey][_latitudeKey] as double;
    final longitude = json[_locationKey][_longitudeKey] as double;
    return LocationEntity(latitude, longitude);
  }
}
