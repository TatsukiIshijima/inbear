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

  final TextEditingController _addressTextEditingController = TextEditingController();

  @override
  void dispose() {
    _addressTextEditingController.dispose();
    super.dispose();
  }


  Future<void> fetchAddress() async {
    var result = await _addressRepositoryImpl.fetchAddress(3070011);
    var address = '${result.prefecture}${result.city}${result.street}';
    _addressTextEditingController.text = address;
    //notifyListeners();
  }
}