import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String selectScheduleId;
  final DateTime createdAt;

  UserEntity(
      this.uid, this.name, this.email, this.selectScheduleId, this.createdAt);

  static const _uidKey = 'uid';
  static const _nameKey = 'name';
  static const _emailKey = 'email';
  static const _selectScheduleIdKey = 'select_schedule_id';
  static const _createdAtKey = 'created_at';

  Map<String, dynamic> toMap() => {
        _uidKey: uid,
        _nameKey: name,
        _emailKey: email,
        _selectScheduleIdKey: selectScheduleId,
        _createdAtKey: createdAt
      };

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    var uid = map[_uidKey];
    var name = map[_nameKey];
    var email = map[_emailKey];
    var selectScheduleId = map[_selectScheduleIdKey];
    var _createdAt = map[_createdAtKey];
    var createdAt = _createdAt is Timestamp ? _createdAt.toDate() : null;
    return UserEntity(uid, name, email, selectScheduleId, createdAt);
  }
}
