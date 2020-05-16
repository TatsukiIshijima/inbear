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

  Map<String, dynamic> toMap() => <String, dynamic>{
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
    final groom = map[_groomKey] as String;
    final bride = map[_brideKey] as String;
    final dateTime = (map[_dateTimeKey] as Timestamp)?.toDate();
    final address = map[_addressKey] as String;
    final geoPoint = map[_geoPointKey] as GeoPoint;
    final ownerUid = map[_ownerUidKey] as String;
    final createdAt = (map[_createdAtKey] as Timestamp)?.toDate();
    final updatedAt = (map[_updatedAtKey] as Timestamp)?.toDate();
    return ScheduleEntity(groom, bride, dateTime, address, geoPoint, ownerUid,
        createdAt, updatedAt);
  }
}
