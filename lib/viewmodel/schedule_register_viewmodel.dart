import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:intl/intl.dart';

class ScheduleRegisterViewModel extends ChangeNotifier {

  final UserRepositoryImpl _userRepositoryImpl;
  final AddressRepositoryImpl _addressRepositoryImpl;

  ScheduleRegisterViewModel(
    this._userRepositoryImpl,
    this._addressRepositoryImpl
  );

  final TextEditingController postalCodeTextEditingController = TextEditingController();
  final TextEditingController addressTextEditingController = TextEditingController();
  final DateFormat _formatter = new DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');
  final Completer<GoogleMapController> _googleMapController = Completer();

  DateTime scheduledDateTime;
  bool isPostalCodeFormat = false;

  @override
  void dispose() {
    postalCodeTextEditingController.dispose();
    addressTextEditingController.dispose();
    super.dispose();
  }

  void updateDate(DateTime dateTime) {
    scheduledDateTime = dateTime;
    notifyListeners();
  }

  String dateToString(DateTime dateTime) {
    return '${_formatter.format(dateTime)} ~';
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

  void mapCreated(GoogleMapController mapController) {
    _googleMapController.complete(mapController);
  }

  Future<void> convertPostalCodeToLocation() async {
    if (addressTextEditingController.text.isEmpty) {
      return;
    }
    var location = await _addressRepositoryImpl
        .convertToLocation(addressTextEditingController.text);
    if (location != null && _googleMapController != null) {
      //print('lat: ${location.latitude}, lng: ${location.longitude}');
      _googleMapController.future.then((map) {
        var latLng = LatLng(location.latitude, location.longitude);
        map.animateCamera(CameraUpdate.newLatLng(latLng));
      });
    }
  }
}