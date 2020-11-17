import 'package:app/src/utils/dimen.dart';
import 'package:flutter/material.dart';

typedef OnPressed();

class ButtonColorNormal extends StatelessWidget {
  Widget content;
  OnPressed onPressed;
  Color colorData;
  double border;
  double width;
  double height;
  ButtonColorNormal(
      {Key key,
      @required this.content,
      this.onPressed,
      this.border = Dimen.border,
      @required this.colorData,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height != null ? height : 50,
      width: width != null ? width : double.infinity,
      child: RaisedButton(
          splashColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(border)),
          color: colorData,
          onPressed: onPressed != null ? () => {onPressed()} : null,
          child: Center(child: content)),
    );
  }
}
