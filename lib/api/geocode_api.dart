import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:inbear_app/api/geocode_api_impl.dart';

class GeoCodeApi implements GeocodeApiImpl {

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
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //print('Geocoding API Error ${response.statusCode}, ${response.body}');
      throw HttpException(
        'Unexcepted status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(uri)
      );
    }
  }

}