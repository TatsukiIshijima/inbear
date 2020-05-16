import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleSelectItem extends StatelessWidget {
  final String pairName;
  final bool isSelect;
  final VoidCallback onTap;

  ScheduleSelectItem(
      {@required this.pairName, @required this.isSelect, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(12.0),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            leading: const Icon(Icons.people),
            title: Text(
              pairName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: isSelect
                ? Icon(
                    Icons.check,
                    color: Color(0xfff06292),
                  )
                : null,
          )),
      onTap: () => onTap(),
    );
  }
}
