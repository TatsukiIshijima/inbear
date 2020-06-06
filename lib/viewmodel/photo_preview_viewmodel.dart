import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/entity/user_entity.dart';
import 'package:inbear_app/repository/image_repository_impl.dart';
import 'package:inbear_app/repository/schedule_repository_impl.dart';
import 'package:inbear_app/repository/user_repository_impl.dart';
import 'package:inbear_app/viewmodel/base_viewmodel.dart';

import '../status.dart';

class PhotoPreviewStatus extends Status {
  PhotoPreviewStatus(String value) : super(value);

  static const deleteImageSuccess = Status('DELETE_IMAGE_SUCCESS');
}

class PhotoPreviewViewModel extends BaseViewModel {
  final UserRepositoryImpl userRepositoryImpl;
  final ScheduleRepositoryImpl scheduleRepositoryImpl;
  final ImageRepositoryImpl imageRepositoryImpl;

  PhotoPreviewViewModel(this.userRepositoryImpl, this.scheduleRepositoryImpl,
      this.imageRepositoryImpl);

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

  Future<void> executeDeleteImage(
      DocumentSnapshot imageDocumentSnapshot) async {
    await executeFutureOperation(() => _deleteImage(imageDocumentSnapshot));
  }

  Future<void> _deleteImage(DocumentSnapshot imageDocumentSnapshot) async {
    final image = ImageEntity.fromMap(imageDocumentSnapshot.data);
    final user =
        await fromCancelable(userRepositoryImpl.fetchUser()) as UserEntity;
    if (user.selectScheduleId.isEmpty) {
      status = Status.none;
      return;
    }
    await fromCancelable(scheduleRepositoryImpl.deleteImage(
        user.selectScheduleId, imageDocumentSnapshot.documentID));
    await imageRepositoryImpl.deleteImage(image.originalUrl);
    await imageRepositoryImpl.deleteImage(image.thumbnailUrl);
    status = PhotoPreviewStatus.deleteImageSuccess;
  }

  @override
  void dispose() {
    clearGestureDetailsCache();
    super.dispose();
  }
}
