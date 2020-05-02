
// Geocodeing API
// https://developers.google.com/maps/documentation/geocoding/intro#GeocodingRequests
class GeoCode {

  final List<Geometry> geometries;

  GeoCode(this.geometries);

  factory GeoCode.fromJson(Map<String, dynamic> json) {
    var results = json['results'] as List;
    List<Geometry> geometryList = results.map((result) =>
        Geometry.fromJson(result)).toList();
    return GeoCode(geometryList);
  }
}

class Geometry {
  final Location location;

  Geometry(this.location);

  factory Geometry.fromJson(Map<String, dynamic> json) {
    var geometryJson = json['geometry'];
    return Geometry(Location.fromJson(geometryJson));
  }
}

class Location {

  final double latitude;
  final double longitude;

  Location(
    this.latitude,
    this.longitude
  );

  factory Location.fromJson(Map<String, dynamic> json) {
    var latitude = json['location']['lat'];
    var longitude = json['location']['lng'];
    return Location(latitude, longitude);
  }
}