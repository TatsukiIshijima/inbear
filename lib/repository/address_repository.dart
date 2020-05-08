import 'dart:async';
import 'dart:convert';

import 'package:inbear_app/api/address_search_api_impl.dart';
import 'package:inbear_app/api/geocode_api_impl.dart';
import 'package:inbear_app/entity/address_entity.dart';
import 'package:inbear_app/entity/geocode_entity.dart';
import 'package:inbear_app/entity/spot_entity.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';

class AddressRepository implements AddressRepositoryImpl {
  
  final AddressSearchApiImpl _addressSearchApiImpl;
  final GeocodeApiImpl _geocodeApiImpl;
  
  AddressRepository(
    this._addressSearchApiImpl,
    this._geocodeApiImpl
  );

  @override
  Future<AddressEntity> fetchAddress(String zipCode) async {
    var response = await _addressSearchApiImpl.fetchAddress(zipCode);
    var spot = SpotEntity.fromJson(json.decode(response));
    return spot.addresses.length == 0 ? null : spot.addresses.first;
  }

  @override
  Future<LocationEntity> convertToLocation(String address) async {
    var response = await _geocodeApiImpl.convertAddressToGeoCode(address);
    var geoCode = GeoCodeEntity.fromJson(json.decode(response));
    return geoCode.geometries.first.location;
  }

}