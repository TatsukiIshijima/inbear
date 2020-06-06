import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:inbear_app/exception/api/api_exception.dart';

class Api {
  Future<String> get(String uri) async {
    var response = await http.get(uri).timeout(Duration(seconds: 5),
        onTimeout: () =>
            throw TimeoutException('Api TimeoutException \n$uri}'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      if (response.statusCode >= 400 && response.statusCode < 500) {
        throw ApiException(response.statusCode,
            reason: response.reasonPhrase, uri: Uri.parse(uri));
      } else if (response.statusCode >= 500 && response.statusCode < 600) {
        throw InternalServerException();
      }
      throw HttpException(
          'Unexpected status code ${response.statusCode}:'
          ' ${response.reasonPhrase}',
          uri: Uri.parse(uri));
    }
  }
}
