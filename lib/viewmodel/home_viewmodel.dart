import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  int selectIndex = 0;

  void updateIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }
}
