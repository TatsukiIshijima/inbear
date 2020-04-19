import 'package:flutter/cupertino.dart';

class User {
  final String uid;
  final String name;

  User({
    @required
    this.uid,
    @required
    this.name
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'name': name
  };
}