import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoItem extends StatelessWidget {
  final String url;

  PhotoItem(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Ink.image(image: ExtendedNetworkImageProvider(url)),
    );
  }
}
