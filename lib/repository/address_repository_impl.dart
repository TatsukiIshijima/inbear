import 'package:inbear_app/entity/address_entity.dart';
import 'package:inbear_app/entity/geocode_entity.dart';

class AddressRepositoryImpl {
  Future<AddressEntity> fetchAddress(String zipCode) {}
  Future<LocationEntity> convertToLocation(String address) {}
}