import 'package:extended_image/extended_image.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

class PhotoPreviewViewModel extends BaseViewModel {
  final UserRepositoryImpl userRepositoryImpl;

  PhotoPreviewViewModel(this.userRepositoryImpl);

  int currentIndex = 0;

  void updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<bool> checkPoster(ImageEntity imageEntity) async {
    final userId = await userRepositoryImpl.getUid();
    if (userId.isEmpty) {
      return false;
    }
    return imageEntity.posterUid == userId;
  }

  @override
  void dispose() {
    clearGestureDetailsCache();
    super.dispose();
  }
}
