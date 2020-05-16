import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleEntity {
  final String groom;
  final String bride;
  final DateTime dateTime;
  final String address;
  final GeoPoint geoPoint;
  final String ownerUid;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleEntity(this.groom, this.bride, this.dateTime, this.address,
      this.geoPoint, this.ownerUid, this.createdAt, this.updatedAt);

  static const _groomKey = 'groom';
  static const _brideKey = 'bride';
  static const _dateTimeKey = 'date_time';
  static const _addressKey = 'address';
  static const _geoPointKey = 'geo_point';
  static const _ownerUidKey = 'owner_uid';
  static const _createdAtKey = 'created_at';
  static const _updatedAtKey = 'updated_at';

  Map<String, dynamic> toMap() => {
        _groomKey: groom,
        _brideKey: bride,
        _dateTimeKey: dateTime,
        _addressKey: address,
        _geoPointKey: geoPoint,
        _ownerUidKey: ownerUid,
        _createdAtKey: createdAt,
        _updatedAtKey: updatedAt
      };

  factory ScheduleEntity.fromMap(Map<String, dynamic> map) {
    var groom = map[_groomKey];
    var bride = map[_brideKey];
    var _dateTime = map[_dateTimeKey];
    var dateTime = _dateTime is Timestamp ? _dateTime.toDate() : null;
    var address = map[_addressKey];
    var geoPoint = map[_geoPointKey];
    var ownerUid = map[_ownerUidKey];
    var _createdAt = map[_createdAtKey];
    var createdAt = _createdAt is Timestamp ? _createdAt.toDate() : null;
    var _updatedAt = map[_updatedAtKey];
    var updatedAt = _updatedAt is Timestamp ? _updatedAt.toDate() : null;
    return ScheduleEntity(groom, bride, dateTime, address, geoPoint, ownerUid,
        createdAt, updatedAt);
  }
}
