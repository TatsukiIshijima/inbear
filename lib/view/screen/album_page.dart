import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/localize/app_localizations.dart';
import 'package:inbear_app/repository/ImageRepository.dart';
import 'package:inbear_app/repository/user_repository.dart';
import 'package:inbear_app/viewmodel/album_viewmodel.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final resource = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (context) => AlbumViewModel(
        Provider.of<UserRepository>(context, listen: false),
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
    return Scaffold(
      body: Center(child: Text('アルバム'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await viewModel.uploadSelectImages();
        },
        child: Icon(Icons.add),
      ),
    );
  }

}