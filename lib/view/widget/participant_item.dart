import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParticipantItem extends StatelessWidget {
  final String userName;
  final String email;
  final VoidCallback onTap;

  ParticipantItem(
      {@required this.userName, @required this.email, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
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
              )
            ],
          )
          /*
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
         */
          ),
      onTap: () => onTap(),
    );
  }
}
