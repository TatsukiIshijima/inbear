import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/model/schedule.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:intl/intl.dart';

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
        _addressGeoPoint = GeoPoint(latLng.latitude, latLng.longitude);
        map.animateCamera(CameraUpdate.newLatLng(latLng));
      });
    }
  }
  
  Future<void> registerSchedule() async {
    if (scheduledDateTime == null) {
      print('日付が選択されていません。');
      return;
    }
    if (_addressGeoPoint == null) {
      print('住所が地図上で検索できない地点です。');
      return;
    }
    var uid = await _userRepositoryImpl.getUid();
    if (uid.isEmpty) {
      print('未ログイン状態です。');
      return;
    }
    var scheduleId = await _scheduleRepositoryImpl.registerSchedule(
      Schedule(
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
    if (scheduleId.isEmpty) {
      return;
    }
    var result = await _userRepositoryImpl.addScheduleReference(scheduleId);
    if (result.isNotEmpty) {
      return;
    }
  }
}