import 'package:flutter/material.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';

class ScheduleRegisterViewModel extends ChangeNotifier {

  final UserRepositoryImpl _userRepositoryImpl;
  final AddressRepositoryImpl _addressRepositoryImpl;

  ScheduleRegisterViewModel(
    this._userRepositoryImpl,
    this._addressRepositoryImpl
  );

  final TextEditingController postalCodeTextEditingController = TextEditingController();
  final TextEditingController addressTextEditingController = TextEditingController();

  @override
  void dispose() {
    postalCodeTextEditingController.dispose();
    addressTextEditingController.dispose();
    super.dispose();
  }

  Future<void> fetchAddress() async {
    var result = await _addressRepositoryImpl.fetchAddress(postalCodeTextEditingController.text);
    var address = '${result.prefecture}${result.city}${result.street}';
    addressTextEditingController.text = address;
    notifyListeners();
  }

  bool validatePostalCode() {
    var postalCode = postalCodeTextEditingController.text;
    if (postalCode.isEmpty) {
      return false;
    }
    return RegExp(r'/^\d{3}[-]\d{4}$|^\d{3}[-]\d{2}$|^\d{3}$|^\d{5}$|^\d{7}$/').hasMatch(postalCode);
  }
}