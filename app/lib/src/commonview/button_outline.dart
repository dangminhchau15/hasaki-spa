import 'package:app/src/utils/dimen.dart';
import 'package:flutter/material.dart';

typedef OnPressed();

class ButtonOutline extends StatelessWidget {
  Widget content;
  OnPressed onPressed;
  Color colorBackground;
  Color colorOutline;
  String iconAsset;
  String iconAssetLeft;
  double width;
  double height;
  ButtonOutline(
      {Key key,
      this.content,
      this.onPressed,
      @required this.colorBackground,
      @required this.colorOutline,
      this.width,
      this.height,
      this.iconAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 50 : this.height,
      width: width == null ? double.infinity : this.width,
      child: RaisedButton(
        splashColor: Colors.transparent,
        elevation: 0.5,
        highlightElevation: 0.5,
        color: this.colorBackground,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(Dimen.border),
            side: BorderSide(color: this.colorOutline)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            iconAsset != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Image.asset(
                      iconAsset,
                      scale: 3,
                    ),
                  )
                : Container(),
            content,
          ],
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
