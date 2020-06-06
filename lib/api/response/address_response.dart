// 郵便番号検索API ZipCloud
// http://zipcloud.ibsnet.co.jp/doc/api

class AddressResponse {
  final String zipCode;
  final String prefCode;
  final String prefecture;
  final String city;
  final String street;

  AddressResponse(
      this.zipCode, this.prefCode, this.prefecture, this.city, this.street);

  static const _zipCodeKey = 'zipcode';
  static const _prefCodeKey = 'prefcode';
  static const _address1Key = 'address1';
  static const _address2key = 'address2';
  static const _address3Key = 'address3';

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    final zipCode = json[_zipCodeKey] as String;
    final prefCode = json[_prefCodeKey] as String;
    final prefecture = json[_address1Key] as String;
    final city = json[_address2key] as String;
    final street = json[_address3Key] as String;
    return AddressResponse(zipCode, prefCode, prefecture, city, street);
  }
}
