import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
       GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AlbumViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
      await viewModel.fetchImageAtStart());
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async => await viewModel.fetchImageAtStart(),
        child: StreamBuilder(
          stream: viewModel.imagesStream,
          builder: (BuildContext context, AsyncSnapshot<List<ImageEntity>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('エラー ${snapshot.error}'),);
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loading();
              default:
                break;
            }
            return GridView.builder(
                padding: const EdgeInsets.all(4),
                itemCount: snapshot.data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  // ダミーURL 'https://placehold.jp/150x150.png'
                  debugPrint('${snapshot.data[index].thumbnailUrl}');
                  return PhotoItem(snapshot.data[index].thumbnailUrl);
                }
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await viewModel.uploadSelectImages();
        },
        child: Icon(Icons.add),
      ),
    );
  }

}