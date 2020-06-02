import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inbear_app/entity/image_entity.dart';

class PhotoPreviewPage extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  PhotoPreviewPage(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('写真'),
        centerTitle: true,
      ),
      body: ExtendedImageGesturePageView.builder(
        itemBuilder: (context, index) {
          final imageEntity = ImageEntity.fromMap(documentSnapshot.data);
          return ExtendedImage.network(
            imageEntity.originalUrl,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) => GestureConfig(
                inPageView: true, initialScale: 1.0, cacheGesture: true),
          );
        },
        itemCount: 1,
        onPageChanged: (index) {},
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
