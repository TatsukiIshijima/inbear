import 'package:inbear_app/datasource/person_datasource_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonDataSource implements PersonDataSourceImpl {
  static const _emailKey = 'email';

  @override
  Future<String> loadEmailAddress() async {
    final sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getString(_emailKey) ?? '';
  }

  @override
  Future<void> saveEmailAddress(String email) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString(_emailKey, email);
  }
}
