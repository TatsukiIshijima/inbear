// Geocodeing API
// https://developers.google.com/maps/documentation/geocoding/intro#GeocodingRequests

import 'package:inbear_app/exception/api/api_exception.dart';

class GeoCodeResponse {
  final List<GeometryEntity> geometries;

  GeoCodeResponse(this.geometries);

  static const _resultsKey = 'results';
  static const _statusKey = 'status';

  static const _ok = 'OK';
  static const _zeroResults = 'ZERO_RESULTS';
  static const _overDailyLimit = 'OVER_DAILY_LIMIT';
  static const _requestDenied = 'REQUEST_DENIED';
  static const _invalidRequest = 'INVALID_REQUEST';

  factory GeoCodeResponse.fromJson(Map<String, dynamic> json) {
    final status = json[_statusKey] as String;
    if (status == _ok) {
      final results = json[_resultsKey] as List<Object>;
      final geometryList = results
          .map((result) =>
              GeometryEntity.fromJson(result as Map<String, dynamic>))
          .toList();
      return GeoCodeResponse(geometryList);
    } else if (status == _zeroResults) {
      throw GeocodeApiException(405);
    } else if (status == _overDailyLimit) {
      throw GeocodeApiException(411);
    } else if (status == _requestDenied) {
      throw GeocodeApiException(401);
    } else if (status == _invalidRequest) {
      throw GeocodeApiException(400);
    } else {
      throw InternalServerException();
    }
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
