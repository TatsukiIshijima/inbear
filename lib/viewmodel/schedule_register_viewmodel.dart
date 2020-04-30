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

  bool isPostalCodeFormat = false;

  @override
  void dispose() {
    postalCodeTextEditingController.dispose();
    addressTextEditingController.dispose();
    super.dispose();
  }

  Future<void> fetchAddress() async {
    var result = await _addressRepositoryImpl.fetchAddress(postalCodeTextEditingController.text);
    if (result == null) {
      return;
    }
    var address = '${result.prefecture}${result.city}${result.street}';
    addressTextEditingController.text = address;
    notifyListeners();
  }

  void setPostalCodeInputEvent() {
    postalCodeTextEditingController.addListener(() {
      isPostalCodeFormat = validatePostalCode();
      notifyListeners();
    });
  }

  bool validatePostalCode() {
    var postalCode = postalCodeTextEditingController.text;
    if (postalCode.isEmpty) {
      return false;
    }
    return RegExp(r'^[0-9]{7}$').hasMatch(postalCode);
  }
}