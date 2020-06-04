import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class Api {
  Future<String> get(String uri) async {
    var response = await http.get(uri).timeout(Duration(seconds: 5),
        onTimeout: () =>
            throw TimeoutException('Api TimeoutException \n$uri}'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw HttpException(
          'Unexcepted status code ${response.statusCode}:'
          ' ${response.reasonPhrase}',
          uri: Uri.parse(uri));
    }
  }
}
