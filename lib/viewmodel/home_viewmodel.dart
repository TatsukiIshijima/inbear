import 'package:flutter/cupertino.dart';
import 'package:inbear_app/repository/app_config_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  final AppConfigRepositoryImpl _appConfigRepositoryImpl;

  HomeViewModel(this._appConfigRepositoryImpl);

  final PageController pageController = PageController();
  final PageController tutorialPageController = PageController();

  int selectIndex = 0;
  // スケジュール切り替え用のフラグ
  bool isSelectScheduleChanged = false;
  bool isFirstLaunchDone = false;

  void jumpToPage(int index) {
    pageController.jumpToPage(index);
  }

  void updateIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }

  void updateSelectScheduleChangedFlag() {
    isSelectScheduleChanged = !isSelectScheduleChanged;
    notifyListeners();
  }

  Future<void> saveFirstLaunchState() async {
    await _appConfigRepositoryImpl.saveFirstLaunchState(true);
    isFirstLaunchDone = true;
    notifyListeners();
  }

  Future<void> loadFirstLaunchState() async {
    isFirstLaunchDone = await _appConfigRepositoryImpl.loadFirstLaunchState();
    notifyListeners();
  }
}
