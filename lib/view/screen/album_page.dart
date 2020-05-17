import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/custom_exceptions.dart';
import 'package:inbear_app/entity/image_entity.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/ImageRepository.dart';
import 'package:inbear_app/repository/schedule_respository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/view/widget/loading.dart';
import 'package:inbear_app/view/widget/photo_item.dart';
import 'package:inbear_app/viewmodel/album_viewmodel.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => AlbumViewModel(
        Provider.of<UserRepository>(context, listen: false),
        Provider.of<ScheduleRepository>(context, listen: false),
        Provider.of<ImageRepository>(context, listen: false),
      ),
      child: AlbumPageContent(resource),
    );
  }
}

class AlbumPageContent extends StatelessWidget {
  final AppLocalizations resource;

  AlbumPageContent(this.resource);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AlbumViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      viewModel.setScrollListener();
      await viewModel.fetchImageAtStart();
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AlbumGridView(resource, viewModel),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await viewModel.uploadSelectImages(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AlbumGridView extends StatelessWidget {
  final AppLocalizations resource;
  final AlbumViewModel albumViewModel;

  AlbumGridView(this.resource, this.albumViewModel);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Widget _errorText(String errorMessage) {
    return Text(
      errorMessage,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async => await albumViewModel.fetchImageAtStart(),
      child: StreamBuilder<List<ImageEntity>>(
        initialData: null,
        stream: albumViewModel.imagesStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: Loading());
            default:
              if (snapshot.hasError) {
                if (snapshot.error is UnLoginException) {
                  return Center(child: _errorText(resource.unloginError));
                } else if (snapshot.error is DocumentNotExistException) {
                  return Center(child: _errorText(resource.notExistDataError));
                } else if (snapshot.error is NoSelectScheduleException) {
                  return Center(
                      child: _errorText(resource.noSelectScheduleError));
                } else {
                  return Center(child: _errorText(resource.generalError));
                }
              } else if (!snapshot.hasData) {
                return Center(
                    child: _errorText(resource.albumNotRegisterMessage));
              } else if (snapshot.data.isEmpty) {
                return Center(
                    child: _errorText(resource.albumNotRegisterMessage));
              } else {
                return GridView.builder(
                    padding: const EdgeInsets.all(4),
                    itemCount: snapshot.data.length,
                    controller: albumViewModel.scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return PhotoItem(snapshot.data[index].thumbnailUrl);
                    });
              }
          }
        },
      ),
    );
  }
}
