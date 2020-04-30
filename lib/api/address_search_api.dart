import 'package:http/http.dart' as http;
import 'package:inbear_app/api/address_search_api_impl.dart';

class AddressSearchApi implements AddressSearchApiImpl {

  @override
  Future<String> fetchAddress(int zipCode) async {
    var response = await http.get('https://zip-cloud.appspot.com/api/search?zipcode=$zipCode&limit=1');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get address.');
    }
  }

}