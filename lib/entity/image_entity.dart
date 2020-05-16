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

  Map<String, dynamic> toMap() => {
        _originalUrlKey: originalUrl,
        _thumbnailUrlKey: thumbnailUrl,
        _posterUidKey: posterUid,
        _createdAtKey: createdAt
      };

  factory ImageEntity.fromMap(Map<String, dynamic> map) {
    final originalUrl = map[_originalUrlKey];
    final thumbnailUrl = map[_thumbnailUrlKey];
    final posterUid = map[_posterUidKey];
    final _createdAt = map[_createdAtKey];
    final createdAt = _createdAt is Timestamp ? _createdAt.toDate() : null;
    return ImageEntity(originalUrl, thumbnailUrl, posterUid, createdAt);
  }
}
