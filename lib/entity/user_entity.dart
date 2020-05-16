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

  Map<String, dynamic> toMap() => <String, dynamic>{
        _uidKey: uid,
        _nameKey: name,
        _emailKey: email,
        _selectScheduleIdKey: selectScheduleId,
        _createdAtKey: createdAt
      };

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    final uid = (map[_uidKey]) as String;
    final name = map[_nameKey] as String;
    final email = map[_emailKey] as String;
    final selectScheduleId = map[_selectScheduleIdKey] as String;
    final createdAt = (map[_createdAtKey] as Timestamp)?.toDate();
    return UserEntity(uid, name, email, selectScheduleId, createdAt);
  }
}
