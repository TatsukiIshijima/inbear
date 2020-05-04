import 'dart:async';
import 'dart:convert';

import 'package:inbear_app/api/address_search_api_impl.dart';
import 'package:inbear_app/api/geocode_api_impl.dart';
import 'package:inbear_app/model/address.dart';
import 'package:inbear_app/model/geocode.dart';
import 'package:inbear_app/model/spot.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';

class AddressRepository implements AddressRepositoryImpl {
  
  final AddressSearchApiImpl _addressSearchApiImpl;
  final GeocodeApiImpl _geocodeApiImpl;
  
  AddressRepository(
    this._addressSearchApiImpl,
    this._geocodeApiImpl
  );

  @override
  Future<Address> fetchAddress(String zipCode) async {
    var response = await _addressSearchApiImpl.fetchAddress(zipCode);
    var spot = Spot.fromJson(json.decode(response));
    return spot.addresses.first;
  }

  @override
  Future<Location> convertToLocation(String address) async {
    var response = await _geocodeApiImpl.convertAddressToGeoCode(address);
    var geoCode = GeoCode.fromJson(json.decode(response));
    return geoCode.geometries.first.location;
  }

}