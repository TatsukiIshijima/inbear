import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/image_repository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/status.dart';
import 'package:inbear_app/view/screen/base_page.dart';
import 'package:inbear_app/view/widget/closed_question_dialog.dart';
import 'package:inbear_app/viewmodel/photo_preview_viewmodel.dart';
import 'package:provider/provider.dart';

class PhotoPreviewPage extends StatelessWidget {
  final List<DocumentSnapshot> documentSnapshots;
  final int currentIndex;

  PhotoPreviewPage(this.documentSnapshots, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      viewModel: PhotoPreviewViewModel(
          Provider.of<UserRepository>(context, listen: false),
          Provider.of<ScheduleRepository>(context, listen: false),
          Provider.of<ImageRepository>(context, listen: false)),
      child: PhotoPreviewPageContent(documentSnapshots, currentIndex),
    );
  }
}

class PhotoPreviewPageContent extends StatelessWidget {
  final List<DocumentSnapshot> documentSnapshots;
  final int currentIndex;

  PhotoPreviewPageContent(this.documentSnapshots, this.currentIndex);

  void _showDeleteConfirmDialog(
      BuildContext context, Future<void> Function() function) {
    final resource = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog<ClosedQuestionDialog>(
          context: context,
          builder: (context) => ClosedQuestionDialog(
                title: resource.photoPreviewDeleteConfirmTitle,
                message: resource.photoPreviewDeleteConfirmMessage,
                positiveButtonTitle: resource.defaultPositiveButtonTitle,
                negativeButtonTitle: resource.defaultNegativeButtonTitle,
                onPositiveButtonPressed: () async {
                  Navigator.pop(context);
                  await function();
                },
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    final viewModel =
        Provider.of<PhotoPreviewViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(resource.photoPreviewTitle),
        centerTitle: true,
        actions: <Widget>[
          Selector<PhotoPreviewViewModel, int>(
            selector: (context, viewModel) => viewModel.currentIndex,
            builder: (context, currentIndex, child) {
              return FutureBuilder<bool>(
                initialData: false,
                future: viewModel.checkPoster(
                    ImageEntity.fromMap(documentSnapshots[currentIndex].data)),
                builder: (context, snapshot) {
                  if (snapshot.data) {
                    return IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmDialog(
                            context,
                            () async => await viewModel.executeDeleteImage(
                                documentSnapshots[currentIndex])));
                  } else {
                    return Container();
                  }
                },
              );
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          PhotoImage(documentSnapshots, currentIndex),
          DeleteImageResult()
        ],
      ),
    );
  }
}

class PhotoImage extends StatelessWidget {
  final List<DocumentSnapshot> documentSnapshots;
  final int currentIndex;

  PhotoImage(this.documentSnapshots, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<PhotoPreviewViewModel>(context, listen: false);
    return Selector<PhotoPreviewViewModel, int>(
      selector: (context, viewModel) => viewModel.currentIndex,
      builder: (context, currentIndex, child) =>
          ExtendedImageGesturePageView.builder(
        itemBuilder: (context, index) {
          final imageEntity =
              ImageEntity.fromMap(documentSnapshots[index].data);
          return ExtendedImage.network(
            imageEntity.originalUrl,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) => GestureConfig(
                inPageView: true, initialScale: 1.0, cacheGesture: true),
          );
        },
        itemCount: documentSnapshots.length,
        onPageChanged: (index) => viewModel.updateIndex(index),
        controller: PageController(initialPage: this.currentIndex),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class DeleteImageResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PhotoPreviewViewModel, String>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case Status.success:
            WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) => Navigator.pop(context, true));
            break;
        }
        return Container();
      },
    );
  }
}
