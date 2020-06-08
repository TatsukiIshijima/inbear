import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inbear_app/api/response/address_response.dart';
import 'package:inbear_app/api/response/geocode_response.dart';
import 'package:inbear_app/entity/schedule_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/exception/api/api_exception.dart';
import 'package:inbear_app/repository/address_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';
import 'package:intl/intl.dart';

class ScheduleRegisterStatus extends Status {
  ScheduleRegisterStatus(String value) : super(value);

  static const fetchAddressSuccess = Status('FETCH_ADDRESS_SUCCESS');
  static const convertLocationSuccess = Status('CONVERT_LOCATION_SUCCESS');
  static const registerScheduleSuccess = Status('REGISTER_SCHEDULE_SUCCESS');
  static const unSelectDateError = Status('UN_SELECT_DATE_ERROR');
  static const invalidPostalCodeError = Status('INVALID_POSTAL_CODE_ERROR');
  static const unableSearchAddressError = Status('UNABLE_SEARCH_ADDRESS_ERROR');
  static const overDailyLimitError = Status('OVER_DAILY_LIMIT_ERROR');
  static const requestDeniedError = Status('REQUEST_DENIED_ERROR');
  static const invalidRequestError = Status('INVALID_REQUEST_ERROR');
}

class ScheduleRegisterViewModel extends BaseViewModel {
  final UserRepositoryImpl userRepositoryImpl;
  final ScheduleRepositoryImpl scheduleRepositoryImpl;
  final AddressRepositoryImpl _addressRepositoryImpl;

  ScheduleRegisterViewModel(this.userRepositoryImpl,
      this.scheduleRepositoryImpl, this._addressRepositoryImpl);

  final TextEditingController groomTextEditingController =
      TextEditingController();
  final TextEditingController brideTextEditingController =
      TextEditingController();
  final TextEditingController postalCodeTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
  final DateFormat _formatter = DateFormat('yyyy年MM月dd日(E) HH:mm', 'ja_JP');
  final Completer<GoogleMapController> _googleMapController = Completer();

  GeoPoint addressGeoPoint;
  DateTime scheduledDateTime;
  bool isPostalCodeFormat = false;

  @override
  void dispose() {
    groomTextEditingController.dispose();
    brideTextEditingController.dispose();
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

  Future<void> executeFetchAddress() async =>
      await executeFutureOperation(() => _fetchAddress());

  Future<void> _fetchAddress() async {
    final result = (await fromCancelable(_addressRepositoryImpl.fetchAddress(
        postalCodeTextEditingController.text))) as AddressResponse;
    if (result == null) {
      status = ScheduleRegisterStatus.invalidPostalCodeError;
      notifyListeners();
      return;
    }
    final address = '${result.prefecture}${result.city}${result.street}';
    addressTextEditingController.text = address;
    status = ScheduleRegisterStatus.fetchAddressSuccess;
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

  Future<void> executeConvertPostalCode() async =>
      await executeFutureOperation(() => _convertPostalCodeToLocation());

  Future<void> _convertPostalCodeToLocation() async {
    try {
      if (addressTextEditingController.text.isEmpty) {
        status = Status.none;
        notifyListeners();
        return;
      }
      final location = (await fromCancelable(_addressRepositoryImpl
              .convertToLocation(addressTextEditingController.text)))
          as LocationEntity;
      if (location != null && _googleMapController != null) {
        final map = (await fromCancelable(_googleMapController.future))
            as GoogleMapController;
        final latLng = LatLng(location.latitude, location.longitude);
        addressGeoPoint = GeoPoint(latLng.latitude, latLng.longitude);
        await fromCancelable(map.animateCamera(CameraUpdate.newLatLng(latLng)));
        status = ScheduleRegisterStatus.convertLocationSuccess;
      } else {
        status = ScheduleRegisterStatus.unableSearchAddressError;
      }
    } on GeocodeApiException catch (error) {
      switch (error.code) {
        case 405:
          status = ScheduleRegisterStatus.unableSearchAddressError;
          break;
        case 411:
          status = ScheduleRegisterStatus.overDailyLimitError;
          break;
        case 401:
          status = ScheduleRegisterStatus.requestDeniedError;
          break;
        case 400:
          status = ScheduleRegisterStatus.invalidRequestError;
          break;
      }
    }
    notifyListeners();
  }

  Future<void> executeRegisterSchedule() async =>
      await executeFutureOperation(() => _registerSchedule());

  Future<void> _registerSchedule() async {
    if (scheduledDateTime == null) {
      status = ScheduleRegisterStatus.unSelectDateError;
      notifyListeners();
      return;
    }
    if (addressGeoPoint == null) {
      status = ScheduleRegisterStatus.unableSearchAddressError;
      notifyListeners();
      return;
    }
    final user =
        (await fromCancelable(userRepositoryImpl.fetchUser())) as UserEntity;
    final schedule = ScheduleEntity(
        groomTextEditingController.text,
        brideTextEditingController.text,
        scheduledDateTime,
        addressTextEditingController.text,
        addressGeoPoint,
        user.uid,
        DateTime.now(),
        DateTime.now());
    final scheduleId = (await fromCancelable(
        scheduleRepositoryImpl.registerSchedule(schedule, user))) as String;
    await fromCancelable(
        userRepositoryImpl.registerSchedule(scheduleId, schedule));
    await fromCancelable(userRepositoryImpl.selectSchedule(scheduleId));
    status = ScheduleRegisterStatus.registerScheduleSuccess;
    notifyListeners();
  }
}
