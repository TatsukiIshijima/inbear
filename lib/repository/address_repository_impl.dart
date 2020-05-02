import 'package:inbear_app/model/address.dart';
import 'package:inbear_app/model/geocode.dart';

class AddressRepositoryImpl {
  Future<Address> fetchAddress(String zipCode) {}
  Future<Location> convertToLocation(String address) {}
}