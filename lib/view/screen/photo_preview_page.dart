import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Text('${documentSnapshot.documentID}'),
      ),
    );
  }
}
