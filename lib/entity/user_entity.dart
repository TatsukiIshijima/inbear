import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String selectScheduleId;
  final DateTime createdAt;

  UserEntity(
    this.uid,
    this.name,
    this.email,
    this.selectScheduleId,
    this.createdAt
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name,
    'email': email,
    'select_schedule_id': selectScheduleId,
    'created_at': createdAt
  };

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    var uid = map['uid'];
    var name = map['name'];
    var email = map['email'];
    var selectScheduleId = map['select_schedule_id'];
    var _createdAt = map['created_at'];
    var createdAt = _createdAt is Timestamp ? _createdAt.toDate() : null;
    return UserEntity(uid, name, email, selectScheduleId, createdAt);
  }
}