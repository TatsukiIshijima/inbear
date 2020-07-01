import 'package:inbear_app/datasource/app_config_datasource_impl.dart';
import 'package:inbear_app/repository/app_config_repository_impl.dart';

class AppConfigRepository implements AppConfigRepositoryImpl {
  final AppConfigDataSourceImpl _appConfigDataSourceImpl;

  AppConfigRepository(this._appConfigDataSourceImpl);

  @override
  Future<bool> loadFirstLaunchState() async {
    return await _appConfigDataSourceImpl.isFirstLaunch();
  }

  @override
  Future<void> saveFirstLaunchState(bool isFirstLaunch) async {
    await _appConfigDataSourceImpl.saveFirstLaunchState(isFirstLaunch);
  }
}
