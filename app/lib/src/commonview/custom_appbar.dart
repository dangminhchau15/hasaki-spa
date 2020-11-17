import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

typedef OnClickRight();
typedef OnClickLeft();

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  Widget rightWidget;
  bool isHaveBackButton;
  OnClickLeft onClickLeft;
  CustomAppBar(
      {Key key,
      @required this.title,
      this.rightWidget,
      this.isHaveBackButton = true,
      this.onClickLeft})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  ShapeBorder kBackButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(30),
    ),
  );

  Widget kBackBtn = Icon(
    Icons.arrow_back_ios,
    color: ColorData.colorsWhite,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          color: ColorData.primaryColor,
          child: Stack(children: <Widget>[
            SafeArea(child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.isHaveBackButton
                        ? Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.onClickLeft != null) {
                                  widget.onClickLeft();
                                } else {
                                  Navigator.pop(context, true);
                                }
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Hero(tag: 'topBarBtn', child: kBackBtn),
                              ),
                            ),
                          )
                        : Flexible(
                            flex: 1,
                            child: Container(
                              width: 60,
                            ),
                          ),
                    widget.title != null
                        ? Flexible(
                            flex: 2,
                            child: Hero(
                              tag: 'title',
                              transitionOnUserGestures: true,
                              child: Align(
                                alignment: Alignment.center,
                                child: Material(
                                  color: ColorData.colorsTransparent,
                                  child: Text(
                                    widget.title,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: ColorData.colorsWhite,
                                        fontFamily:
                                            FontsName.textHelveticaNeueBold,
                                        fontSize: FontsSize.large),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Flexible(
                      flex: widget.title != null ? 1 : 2,
                      child: IntrinsicWidth(
                          child: widget.rightWidget == null
                              ? Container(
                                  color: ColorData.colorsTransparent,
                                  width: 60,
                                )
                              : Center(
                                  child: widget.rightWidget,
                                )),
                    )
                  ],
                ),
              );
            }))
          ]),
        ),
      ),
    );
  }
}