// 郵便番号検索API ZipCloud
// http://zipcloud.ibsnet.co.jp/doc/api

class AddressEntity {

  final String zipCode;
  final String prefCode;
  final String prefecture;
  final String city;
  final String street;

  AddressEntity(
    this.zipCode,
    this.prefCode,
    this.prefecture,
    this.city,
    this.street
  );

  static const _zipCodeKey = 'zipcode';
  static const _prefCodeKey = 'prefcode';
  static const _address1Key = 'address1';
  static const _address2key = 'address2';
  static const _address3Key = 'address3';

  factory AddressEntity.fromJson(Map<String, dynamic> json) {
    var zipCode = json[_zipCodeKey];
    var prefCode = json[_prefCodeKey];
    var prefecture = json[_address1Key];
    var city = json[_address2key];
    var street = json[_address3Key];
    return AddressEntity(zipCode, prefCode, prefecture, city, street);
  }
}