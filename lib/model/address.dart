// 郵便番号検索API ZipCloud
// http://zipcloud.ibsnet.co.jp/doc/api

class Address {

  final String zipCode;
  final String prefCode;
  final String prefecture;
  final String city;
  final String street;

  Address(
    this.zipCode,
    this.prefCode,
    this.prefecture,
    this.city,
    this.street
  );

  factory Address.fromJson(Map<String, dynamic> json) {
    var zipCode = json['zipcode'];
    var prefCode = json['prefcode'];
    var prefecture = json['address1'];
    var city = json['address2'];
    var street = json['address3'];
    return Address(zipCode, prefCode, prefecture, city, street);
  }
}