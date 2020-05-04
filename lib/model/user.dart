

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String selectScheduleId;
  final DateTime createdAt;

  User(
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

  factory User.fromMap(Map<String, dynamic> map) {
    var uid = map['uid'];
    var name = map['name'];
    var email = map['email'];
    var selectScheduleId = map['select_schedule_id'];
    var _createdAt = map['created_at'];
    var createdAt = _createdAt is Timestamp ? _createdAt.toDate() : null;
    return User(uid, name, email, selectScheduleId, createdAt);
  }
}