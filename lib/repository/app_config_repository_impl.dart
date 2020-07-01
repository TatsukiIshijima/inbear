abstract class AppConfigRepositoryImpl {
  Future<void> saveFirstLaunchState(bool isFirstLaunch);
  Future<bool> loadFirstLaunchState();
}
