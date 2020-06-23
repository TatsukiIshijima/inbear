import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/image_repository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/routes.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/centering_error_message.dart';
import 'package:inbear_app/view/widget/default_dialog.dart';
import 'package:inbear_app/view/widget/photo_item.dart';
import 'package:inbear_app/view/widget/reload_button.dart';
import 'package:inbear_app/viewmodel/album_viewmodel.dart';
import 'package:inbear_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      viewModel: AlbumViewModel(
        Provider.of<UserRepository>(context, listen: false),
        Provider.of<ScheduleRepository>(context, listen: false),
        Provider.of<ImageRepository>(context, listen: false),
      ),
      child: AlbumPageContent(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AlbumPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AlbumViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.setScrollListener();
      await viewModel.checkSelectedSchedule();
      await viewModel.executeFetchImageAtStart();
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AlbumGridView(),
          UploadResult(),
          ScheduleChangeReceiver()
        ],
      ),
      floatingActionButton: AddPhotoButton(),
    );
  }
}

class AlbumGridView extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<AlbumViewModel>(context, listen: false);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async => await viewModel.executeFetchImageAtStart(),
      // プレビュー画面でPageViewを使用する場合、documentId が使えた方が
      // 都合が良いので、あえて documentSnapshot 形式で流している
      child: StreamBuilder<List<DocumentSnapshot>>(
        initialData: null,
        stream: viewModel.imagesStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.hasError) {
                if (snapshot.error is TimeoutException) {
                  return ReloadButton(
                    onPressed: () async =>
                        await viewModel.executeFetchImageAtStart(),
                  );
                } else {
                  return CenteringErrorMessage(
                    resource,
                    exception: snapshot.error,
                  );
                }
              } else if (!snapshot.hasData) {
                return CenteringErrorMessage(resource,
                    message: resource.albumNotRegisterMessage);
              } else if (snapshot.data.isEmpty) {
                return CenteringErrorMessage(resource,
                    message: resource.albumNotRegisterMessage);
              } else {
                return GridView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: snapshot.data.length,
                    controller: viewModel.scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      final imageEntity =
                          ImageEntity.fromMap(snapshot.data[index].data);
                      return PhotoItem(imageEntity.thumbnailUrl, () async {
                        final result = await Routes.goToPhotoPreview(
                            context, snapshot.data, index);
                        if (result != null && result) {
                          await viewModel.executeFetchImageAtStart();
                        }
                      });
                    });
              }
          }
        },
      ),
    );
  }
}

class UploadResult extends StatelessWidget {
  void _showErrorDialog(BuildContext context, String title, String message) {
    final resource = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<DefaultDialog>(
          context: context,
          builder: (context) => DefaultDialog(
                title,
                message,
                positiveButtonTitle: resource.defaultPositiveButtonTitle,
                onPositiveButtonPressed: () {},
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel = Provider.of<AlbumViewModel>(context, listen: false);
    return Selector<AlbumViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case AlbumStatus.uploadImageSuccess:
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async =>
                await viewModel.executeFetchImageAtStart());
            break;
          case AlbumStatus.noSelectScheduleError:
            _showErrorDialog(context, resource.uploadImageErrorTitle,
                resource.noSelectScheduleError);
            break;
          case AlbumStatus.permissionDeniedError:
            _showErrorDialog(context, resource.permissionErrorTitle,
                resource.photoPermissionDeniedError);
            break;
          case AlbumStatus.permissionPermanentlyDeniedError:
            _showErrorDialog(context, resource.permissionErrorTitle,
                resource.photoPermissionPermanentlyDeniedError);
            break;
          case AlbumStatus.imageUploadError:
            _showErrorDialog(context, resource.uploadImageErrorTitle,
                resource.uploadImageError);
            break;
        }
        return Container();
      },
    );
  }
}

class AddPhotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AlbumViewModel>(context, listen: false);
    return Selector<AlbumViewModel, bool>(
      selector: (context, viewModel) => viewModel.isSelectedSchedule,
      builder: (context, isSelectedSchedule, child) {
        if (isSelectedSchedule) {
          return FloatingActionButton(
            heroTag: 'AddPhoto',
            onPressed: () async => await viewModel.executeUploadSelectImages(),
            child: const Icon(Icons.add_photo_alternate),
          );
        }
        return Container();
      },
    );
  }
}

class ScheduleChangeReceiver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AlbumViewModel>(context, listen: false);
    return Selector<HomeViewModel, bool>(
      selector: (context, viewModel) => viewModel.isSelectScheduleChanged,
      builder: (context, isSelectScheduleChanged, child) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) async => await viewModel.executeFetchImageAtStart());
        return Container();
      },
    );
  }
}
