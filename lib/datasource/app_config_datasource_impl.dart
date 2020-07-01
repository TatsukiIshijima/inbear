abstract class AppConfigDataSourceImpl {
  Future<void> saveFirstLaunchState(bool isFirstLaunch);
  Future<bool> isFirstLaunch();
}
