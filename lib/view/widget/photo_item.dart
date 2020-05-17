import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoItem extends StatelessWidget {
  final String url;

  PhotoItem(this.url);

  static const _imageWidth = 300.0;
  static const _imageHeight = 300.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ExtendedImage.network(
      url,
      width: _imageWidth,
      height: _imageHeight,
      fit: BoxFit.cover,
      cache: true,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: Icon(Icons.image),
            );
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: _imageWidth,
              height: _imageHeight,
              fit: BoxFit.cover,
            );
          case LoadState.failed:
            return Center(child: Icon(Icons.error));
          default:
            return Container();
        }
      },
    ));
  }
}
