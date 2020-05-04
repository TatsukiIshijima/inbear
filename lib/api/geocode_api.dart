import 'package:inbear_app/api/api.dart';
import 'package:inbear_app/api/geocode_api_impl.dart';

class GeoCodeApi extends Api implements GeocodeApiImpl {

  final String apiKey;

  GeoCodeApi(
    this.apiKey
  );

  @override
  Future<String> convertAddressToGeoCode(String address) async {
    var uri = 'https://maps.googleapis.com/maps/api/geocode/json'
        '?address=$address'
        '&language=ja'
        '&region=jp'
        '&key=${this.apiKey}';
    return await get(uri);
  }

}