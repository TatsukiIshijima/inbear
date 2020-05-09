import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:intl/intl.dart';

class ScheduleRegisterStatus extends Status {
  static const fetchAddressSuccess = 'FETCH_ADDRESS_SUCCESS';
  static const convertLocationSuccess = 'CONVERT_LOCATION_SUCCESS';
  static const unSelectDateError = 'UN_SELECT_DATE_ERROR';
  static const invalidPostalCodeError = 'INVALID_POSTAL_CODE_ERROR';
  static const unableSearchAddressError = 'UNABLE_SEARCH_ADDRESS_ERROR';
}

class ScheduleRegisterViewModel extends ChangeNotifier {

  final UserRepositoryImpl _userRepositoryImpl;
  final ScheduleRepositoryImpl _scheduleRepositoryImpl;
  final AddressRepositoryImpl _addressRepositoryImpl;

  ScheduleRegisterViewModel(
    this._userRepositoryImpl,
    this._scheduleRepositoryImpl,
    this._addressRepositoryImpl
  );

  final TextEditingController groomTextEditingController = TextEditingController();
  final TextEditingController brideTextEditingController = TextEditingController();
  final TextEditingController postalCodeTextEditingController = TextEditingController();
  final TextEditingController addressTextEditingController = TextEditingController();
  final DateFormat _formatter = new DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');
  final Completer<GoogleMapController> _googleMapController = Completer();

  GeoPoint _addressGeoPoint;
  DateTime scheduledDateTime;
  bool isPostalCodeFormat = false;
  String status = Status.none;

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
    try {
      status = Status.loading;
      notifyListeners();
      var result = await _addressRepositoryImpl.fetchAddress(postalCodeTextEditingController.text);
      if (result == null) {
        status = ScheduleRegisterStatus.invalidPostalCodeError;
        notifyListeners();
        return;
      }
      var address = '${result.prefecture}${result.city}${result.street}';
      addressTextEditingController.text = address;
      status = ScheduleRegisterStatus.fetchAddressSuccess;
    } on TimeoutException {
      status = Status.timeoutError;
    } on HttpException {
      status = Status.httpError;
    } on SocketException {
      status = Status.socketError;
    }
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
    try {
      if (addressTextEditingController.text.isEmpty) {
        return;
      }
      status = Status.loading;
      notifyListeners();
      var location = await _addressRepositoryImpl
          .convertToLocation(addressTextEditingController.text);
      if (location != null && _googleMapController != null) {
          debugPrint('lat: ${location.latitude}, lng: ${location.longitude}');
          _googleMapController.future.then((map) {
          var latLng = LatLng(location.latitude, location.longitude);
          _addressGeoPoint = GeoPoint(latLng.latitude, latLng.longitude);
          map.animateCamera(CameraUpdate.newLatLng(latLng));
          status = ScheduleRegisterStatus.convertLocationSuccess;
        });
      } else {
        status = ScheduleRegisterStatus.unableSearchAddressError;
      }
    } on TimeoutException {
      status = Status.timeoutError;
    } on HttpException {
      status = Status.httpError;
    } on SocketException {
      status = Status.socketError;
    }
    notifyListeners();
  }
  
  Future<void> registerSchedule() async {
    try {
      status = Status.loading;
      notifyListeners();
      if (scheduledDateTime == null) {
        status = ScheduleRegisterStatus.unSelectDateError;
        notifyListeners();
        return;
      }
      if (_addressGeoPoint == null) {
        status = ScheduleRegisterStatus.unableSearchAddressError;
        notifyListeners();
        return;
      }
      var uid = await _userRepositoryImpl.getUid();
      if (uid.isEmpty) {
        throw UnLoginException();
      }
      var scheduleId = await _scheduleRepositoryImpl.registerSchedule(
          ScheduleEntity(
              groomTextEditingController.text,
              brideTextEditingController.text,
              scheduledDateTime,
              addressTextEditingController.text,
              _addressGeoPoint,
              uid,
              DateTime.now(),
              DateTime.now()
          )
      );
      await _userRepositoryImpl.addScheduleReference(scheduleId);
      await _userRepositoryImpl.selectSchedule(scheduleId);
      status = Status.success;
    } on UnLoginException {
      status = Status.unLoginError;
    }
    notifyListeners();
  }
}