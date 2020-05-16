import 'package:cloud_firestore/cloud_firestore.dart';

class ImageEntity {
  final String originalUrl;
  final String thumbnailUrl;
  final String posterUid;
  final DateTime createdAt;

  ImageEntity(
      this.originalUrl, this.thumbnailUrl, this.posterUid, this.createdAt);

  static const _originalUrlKey = 'original_url';
  static const _thumbnailUrlKey = 'thumbnail_url';
  static const _posterUidKey = 'poster_uid';
  static const _createdAtKey = 'created_at';

  Map<String, dynamic> toMap() => <String, dynamic>{
        _originalUrlKey: originalUrl,
        _thumbnailUrlKey: thumbnailUrl,
        _posterUidKey: posterUid,
        _createdAtKey: createdAt
      };

  factory ImageEntity.fromMap(Map<String, dynamic> map) {
    final originalUrl = map[_originalUrlKey] as String;
    final thumbnailUrl = map[_thumbnailUrlKey] as String;
    final posterUid = map[_posterUidKey] as String;
    final createdAt = (map[_createdAtKey] as Timestamp)?.toDate();
    return ImageEntity(originalUrl, thumbnailUrl, posterUid, createdAt);
  }
}
