// Geocodeing API
// https://developers.google.com/maps/documentation/geocoding/intro#GeocodingRequests
class GeoCodeEntity {
  final List<GeometryEntity> geometries;

  GeoCodeEntity(this.geometries);

  static const _resultsKey = 'results';

  factory GeoCodeEntity.fromJson(Map<String, dynamic> json) {
    var results = json[_resultsKey] as List;
    List<GeometryEntity> geometryList =
        results.map((result) => GeometryEntity.fromJson(result)).toList();
    return GeoCodeEntity(geometryList);
  }
}

class GeometryEntity {
  final LocationEntity location;

  GeometryEntity(this.location);

  static const _geometryKey = 'geometry';

  factory GeometryEntity.fromJson(Map<String, dynamic> json) {
    var geometryJson = json[_geometryKey];
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
    var latitude = json[_locationKey][_latitudeKey];
    var longitude = json[_locationKey][_longitudeKey];
    return LocationEntity(latitude, longitude);
  }
}
