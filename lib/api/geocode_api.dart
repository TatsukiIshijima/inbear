import 'package:http/http.dart' as http;
import 'package:inbear_app/api/geocode_api_impl.dart';

class GeoCodeApi implements GeocodeApiImpl {

  final String apiKey;

  GeoCodeApi(
    this.apiKey
  );

  @override
  Future<String> convertAddressToGeoCode(String address) async {
    var response = await http.get('https://maps.googleapis.com/maps/api/geocode/json?address=${address}&language=ja&region=jp&key=${this.apiKey}');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to convert address to geocode.');
    }
  }

}