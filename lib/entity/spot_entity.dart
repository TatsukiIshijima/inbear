import 'address_entity.dart';

// 郵便番号検索API ZipCloud
// http://zipcloud.ibsnet.co.jp/doc/api

class SpotEntity {

  final List<AddressEntity> addresses;

  SpotEntity(this.addresses);

  static const _resultsKey = 'results';

  factory SpotEntity.fromJson(Map<String, dynamic> json) {
    var results = json[_resultsKey] as List;
    List<AddressEntity> addressList = results == null
        ? List<AddressEntity>() :
        results.map((result) => AddressEntity.fromJson(result)).toList();
    return SpotEntity(addressList);
  }
}