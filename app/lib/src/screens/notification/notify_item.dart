import 'package:app/src/blocs/notification_bloc.dart';
import 'package:app/src/models/get_list_notify_response.dart';
import 'package:app/src/models/receipt_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';

typedef void OnNotifyClick(String id);

class NotifyItem extends StatefulWidget {
  List<Notify> notifies;
  int index;
  OnNotifyClick onNotifyClick;

  NotifyItem({this.notifies, this.index, this.onNotifyClick});

  @override
  _NotifyItemState createState() => _NotifyItemState();
}

class _NotifyItemState extends State<NotifyItem> {
  List<Notify> notifies;
  OnNotifyClick onNotifyClick;
  NotificationBloc bloc;
  int index;
  int isRead;

  @override
  void initState() {
    super.initState();
    notifies = widget.notifies;
    index = widget.index;
    onNotifyClick = widget.onNotifyClick;
    isRead = notifies[index].isRead;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onNotifyClick(notifies[index].sId);
      },
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Column(
                    children: [
                      Text(
                        notifies[index].title,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        notifies[index].message,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(notifies[index].createdAt,
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                  alignment: Alignment.topRight,
                  child: isRead == 1
                      ? Icon(Icons.bookmark, color: Colors.grey)
                      : Icon(Icons.bookmark, color: ColorData.primaryColor)),
            )
          ],
        ),
      ),
    );
  }
}
