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

  ScheduleEntity(
    this.groom,
    this.bride,
    this.dateTime,
    this.address,
    this.geoPoint,
    this.ownerUid,
    this.createdAt,
    this.updatedAt
  );

  Map<String, dynamic> toMap() => {
    'groom': groom,
    'bride': bride,
    'date_time': dateTime,
    'address': address,
    'geo_point': geoPoint,
    'owner_uid': ownerUid,
    'created_at': createdAt,
    'updated_at': updatedAt
  };

  factory ScheduleEntity.fromMap(Map<String, dynamic> map) {
    var groom = map['groom'];
    var bride = map['bride'];
    var _dateTime = map['date_time'];
    var dateTime = _dateTime is Timestamp ? _dateTime.toDate() : null;
    var address = map['address'];
    var geoPoint = map['geo_point'];
    var ownerUid = map['owner_uid'];
    var _createdAt = map['created_at'];
    var createdAt = _createdAt is Timestamp ? _createdAt.toDate() : null;
    var _updatedAt = map['updated_at'];
    var updatedAt = _updatedAt is Timestamp ? _updatedAt.toDate() : null;
    return ScheduleEntity(
      groom,
      bride,
      dateTime,
      address,
      geoPoint,
      ownerUid,
      createdAt,
      updatedAt
    );
  }
}