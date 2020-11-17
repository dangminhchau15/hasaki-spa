import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

typedef OnChanged(String text);
typedef OnIconClickListener(TextEditingController controller);

class TextFieldOutline extends StatefulWidget {
  TextEditingController controller;
  bool readOnly = false;
  bool isCenter = false;
  int isPassword = 0;
  String initialValue;
  String stringAssetIconRight;
  String hintText;
  OnChanged onChanged;
  OnIconClickListener onIconClickListener;
  double height = 0;
  bool isHaveDate = false;
  bool isPhoneNumber;
  bool isEnableKeyboardIOS;
  String errorText;
  TextFieldOutline(
      {Key key,
      this.initialValue,
      this.controller,
      this.isPassword,
      this.isCenter,
      this.readOnly,
      this.onIconClickListener,
      this.height,
      this.stringAssetIconRight,
      @required this.hintText,
      this.isPhoneNumber = false,
      this.errorText,
      this.isEnableKeyboardIOS = true,
      this.onChanged})
      : super(key: key);

  _TextFieldOutlineState createState() => _TextFieldOutlineState();
}

class _TextFieldOutlineState extends State<TextFieldOutline> {
  final FocusNode _nodeText = FocusNode();

  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: KeyboardActions(
        autoScroll: false,
        tapOutsideToDismiss: true,
        enable: widget.isEnableKeyboardIOS,
        child: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: ColorData.colorsWhite,
                  border: Border.all(
                    color: ColorData.colorsBorderOutline,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(Dimen.border),
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    new Expanded(
                      child: Container(
                        color: ColorData.colorsWhite,
                        height: widget.height == 0 ? 50 : widget.height,
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          obscureText: widget.isPassword == 0 ? false : true,
                          textAlign: widget.isCenter == true
                              ? TextAlign.center
                              : TextAlign.start,
                          controller: widget.controller != null
                              ? widget.controller
                              : _controller,
                          readOnly:
                              widget.readOnly == true ? widget.readOnly : false,
                          focusNode: _nodeText,
                          onChanged: (value) {
                            widget.onChanged(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${widget.hintText}',
                            hintStyle: TextStyle(
                              color: ColorData.textGray.withOpacity(0.6),
                              fontSize: FontsSize.normal,
                            ),
                          ),
                          keyboardType:
                              widget.isPhoneNumber ? TextInputType.phone : null,
                          inputFormatters: [
                            new BlacklistingTextInputFormatter(new RegExp(
                                '[\\,|\\-|\\(|\\)|\\;|\\/|\\*|\\#]')),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: widget.stringAssetIconRight != null
                          ? InkWell(
                              onTap: () {
                                widget.onIconClickListener(_controller);
                              },
                              child: Image.asset(
                                widget.stringAssetIconRight,
                                width: 20,
                                height: 20,
                                scale: 2.5,
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              widget.errorText == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "${widget.errorText}",
                        style: TextStyle(
                          color: ColorData.colorsRed,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
            ],
          ),
        ),
        config: _buildConfig(context),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        actions: [
          KeyboardAction(
            focusNode: _nodeText,
            toolbarButtons: [
              (node) {
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () => node.unfocus(),
                    child: Text(
                      "Done",
                      style: TextStyle(
                          color: ColorData.primaryColor,
                          fontSize: FontsSize.xlarge),
                    ),
                  ),
                );
              }
            ],
          ),
        ]);
  }
}
