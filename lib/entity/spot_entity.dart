import 'address_entity.dart';

// 郵便番号検索API ZipCloud
// http://zipcloud.ibsnet.co.jp/doc/api

class SpotEntity {
  final List<AddressEntity> addresses;

  SpotEntity(this.addresses);

  static const _resultsKey = 'results';

  factory SpotEntity.fromJson(Map<String, dynamic> json) {
    final results = json[_resultsKey] as List<Object>;
    final addressList = results == null
        ? <AddressEntity>[]
        : results
            .map<AddressEntity>((result) =>
                AddressEntity.fromJson(result as Map<String, dynamic>))
            .toList();
    return SpotEntity(addressList);
  }
}
