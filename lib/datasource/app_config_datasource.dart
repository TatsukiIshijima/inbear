import 'package:inbear_app/datasource/app_config_datasource_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigDataSource implements AppConfigDataSourceImpl {
  static const _isAppFirstLaunchKey = 'is_app_first_launch';

  @override
  Future<bool> isFirstLaunch() async {
    final sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getBool(_isAppFirstLaunchKey);
  }

  @override
  Future<void> saveFirstLaunchState(bool isFirstLaunch) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool(_isAppFirstLaunchKey, isFirstLaunch);
  }
}
