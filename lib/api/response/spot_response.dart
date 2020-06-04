import 'address_response.dart';

// 郵便番号検索API ZipCloud
// http://zipcloud.ibsnet.co.jp/doc/api

class SpotResponse {
  final List<AddressResponse> addresses;

  SpotResponse(this.addresses);

  static const _resultsKey = 'results';

  factory SpotResponse.fromJson(Map<String, dynamic> json) {
    final results = json[_resultsKey] as List<Object>;
    final addressList = results == null
        ? <AddressResponse>[]
        : results
            .map<AddressResponse>((result) =>
                AddressResponse.fromJson(result as Map<String, dynamic>))
            .toList();
    return SpotResponse(addressList);
  }
}
