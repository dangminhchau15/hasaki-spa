import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';

class ContainerDialog extends StatelessWidget {
  Widget content;
  double height;
  ContainerDialog({Key key, this.content, @required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: ColorData.background,
        borderRadius: new BorderRadius.all(new Radius.circular(21.0)),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 0),
                  height: 100,
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorData.primaryColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(20.0)),
                  )
                ),
              ],
            ),
          ),
          Expanded(
              flex: 7,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorData.background,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                ),
                child: ClipRRect(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    child: content),
              )),
        ],
      ),
    );
  }
}