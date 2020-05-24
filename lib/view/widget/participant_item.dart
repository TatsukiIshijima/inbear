import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParticipantItem extends StatelessWidget {
  final String userName;
  final String email;
  final bool showAddButton;
  final bool showDeleteButton;
  final VoidCallback addButtonClick;
  final VoidCallback deleteButtonClick;

  ParticipantItem(
      {@required this.userName,
      @required this.email,
      this.showAddButton = false,
      this.showDeleteButton = false,
      this.addButtonClick,
      this.deleteButtonClick});

  Widget _button(String text, VoidCallback onPressed) {
    return RaisedButton(
        onPressed: () => onPressed(),
        child: Text(
          text,
          style: TextStyle(color: Color(0xfff48fb1)),
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          side: BorderSide(color: Color(0xfff48fb1)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(12.0),
        width: MediaQuery.of(context).size.width,
        // アイコンが中央寄せにならなかったため、カスタムして作成
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              child: SizedBox(),
            ),
            if (showAddButton) _button('追加', () => addButtonClick()),
            if (showDeleteButton) _button('削除', () => deleteButtonClick()),
          ],
        ));
  }
}
