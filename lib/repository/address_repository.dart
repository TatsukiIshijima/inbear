import 'dart:convert';

import 'package:inbear_app/api/address_search_api_impl.dart';
import 'package:inbear_app/model/address.dart';
import 'package:inbear_app/model/spot.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';

class AddressRepository implements AddressRepositoryImpl {
  
  final AddressSearchApiImpl _addressSearchApiImpl;
  
  AddressRepository(this._addressSearchApiImpl);

  @override
  Future<Address> fetchAddress(int zipCode) async {
    try {
      var response = await _addressSearchApiImpl.fetchAddress(zipCode);
      var spot = Spot.fromJson(json.decode(response));
      return spot.addresses.first;
  } catch (exception) {
      print(exception);
      return null;
    }
  }

}