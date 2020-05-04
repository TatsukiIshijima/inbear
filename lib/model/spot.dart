import 'package:inbear_app/model/address.dart';

// 郵便番号検索API ZipCloud
// http://zipcloud.ibsnet.co.jp/doc/api

class Spot {

  final List<Address> addresses;

  Spot(this.addresses);

  factory Spot.fromJson(Map<String, dynamic> json) {
    var results = json['results'] as List;
    List<Address> addressList = results == null
        ? List<Address>() :
        results.map((result) => Address.fromJson(result)).toList();
    return Spot(addressList);
  }
}