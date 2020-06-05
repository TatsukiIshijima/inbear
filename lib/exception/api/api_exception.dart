class ApiException implements Exception {
  final int code;
  final String reason;
  final Uri uri;

  ApiException(this.code, {this.reason, this.uri});
}

class InternalServerException implements Exception {}

class GeocodeApiException implements Exception {
  final int code;
  final String reason;

  GeocodeApiException(this.code, {this.reason});
}
