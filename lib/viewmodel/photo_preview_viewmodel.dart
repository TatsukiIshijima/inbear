import 'package:extended_image/extended_image.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class PhotoPreviewViewModel extends BaseViewModel {
  int currentIndex = 0;

  void updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    clearGestureDetailsCache();
    super.dispose();
  }
}
