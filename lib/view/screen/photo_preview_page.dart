import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoPreviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('写真'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('写真プレビュー'),
      ),
    );
  }
}
