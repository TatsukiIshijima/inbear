
// Geocodeing API
// https://developers.google.com/maps/documentation/geocoding/intro#GeocodingRequests
class GeoCodeEntity {

  final List<GeometryEntity> geometries;

  GeoCodeEntity(this.geometries);

  factory GeoCodeEntity.fromJson(Map<String, dynamic> json) {
    var results = json['results'] as List;
    List<GeometryEntity> geometryList = results.map((result) =>
        GeometryEntity.fromJson(result)).toList();
    return GeoCodeEntity(geometryList);
  }
}

class GeometryEntity {
  final LocationEntity location;

  GeometryEntity(this.location);

  factory GeometryEntity.fromJson(Map<String, dynamic> json) {
    var geometryJson = json['geometry'];
    return GeometryEntity(LocationEntity.fromJson(geometryJson));
  }
}

class LocationEntity {

  final double latitude;
  final double longitude;

  LocationEntity(
    this.latitude,
    this.longitude
  );

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    var latitude = json['location']['lat'];
    var longitude = json['location']['lng'];
    return LocationEntity(latitude, longitude);
  }
}