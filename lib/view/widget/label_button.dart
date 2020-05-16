import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  LabelButton({
    @required this.text,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        text,
        style: TextStyle(color: Colors.pink[200], fontSize: 20),
      ),
      onTap: () => onTap(),
    );
  }
}
