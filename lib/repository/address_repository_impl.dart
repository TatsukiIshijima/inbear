import 'package:inbear_app/api/response/address_response.dart';
import 'package:inbear_app/api/response/geocode_response.dart';

abstract class AddressRepositoryImpl {
  Future<AddressResponse> fetchAddress(String zipCode);
  Future<LocationEntity> convertToLocation(String address);
}
