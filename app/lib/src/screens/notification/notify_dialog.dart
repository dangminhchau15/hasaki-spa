import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/notification_bloc.dart';
import 'package:app/src/eventstate/send_detail_notify_event.dart';
import 'package:app/src/eventstate/send_notify_event_success.dart';
import 'package:app/src/models/notify_detail_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';
import '../../utils/color_util.dart';

typedef void OnBackDialog();

class NotifyDialog extends StatefulWidget {
  Detail detail;
  NotificationBloc bloc;
  String id;
  BuildContext context;

  NotifyDialog({this.id, this.detail, this.bloc, this.context});

  @override
  _NotifyDialogState createState() => _NotifyDialogState();
}

class _NotifyDialogState extends State<NotifyDialog> {
  Detail detail;
  String title;
  String message;
  String date;
  int feedback;
  NotificationBloc bloc;
  String id;

  @override
  void initState() {
    super.initState();
    detail = widget.detail;
    title = detail.title;
    message = detail.message;
    bloc = widget.bloc;
    date = detail.createdAt;
    feedback = detail.feedbackAt;
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorData.colorsRed,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close, color: ColorData.colorsWhite)),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thông Báo",
                        style: TextStyle(
                            color: ColorData.colorsBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(title,
                          style: TextStyle(
                              color: ColorData.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(date,
                          style: TextStyle(
                              color: ColorData.textGray,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(message,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Bạn xác nhận đã hiểu",
                              style: TextStyle(
                                  color: ColorData.colorsWhite, fontSize: 14),
                            ),
                          ),
                          color: feedback != null
                              ? ColorData.textGray
                              : ColorData.primaryColor,
                          onPressed: () {
                            if (feedback == null) {
                              Navigator.of(context).pop();
                              bloc.event.add(SendDetailNotityEvent(id: id));
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]);
  }

  void handleEvent(BaseEvent event) {
    if (event is SendNotifyEventSuccess) {

    }
  }
}
