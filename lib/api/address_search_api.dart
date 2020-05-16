import 'package:inbear_app/api/address_search_api_impl.dart';
import 'package:inbear_app/api/api.dart';

class AddressSearchApi extends Api implements AddressSearchApiImpl {
  @override
  Future<String> fetchAddress(String zipCode) async {
    var uri = 'https://zip-cloud.appspot.com/api/search'
        '?zipcode=$zipCode'
        '&limit=1';
    return await get(uri);
  }
}
