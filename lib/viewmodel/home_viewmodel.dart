import 'package:flutter/cupertino.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  final PageController pageController = PageController();

  int selectIndex = 0;

  void jumpToPage(int index) {
    pageController.jumpToPage(index);
  }

  void updateIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }
}
