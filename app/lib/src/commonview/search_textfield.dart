import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

typedef OnChanged(String text);
typedef OnTaped();

class SearchTextField extends StatefulWidget {
  OnChanged onChanged;
  OnTaped onTaped;
  String hintText;
  bool isReadAble;
  SearchTextField(
      {Key key,
      this.onChanged,
      this.onTaped,
      @required this.hintText,
      this.isReadAble = true})
      : super(key: key);

  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final FocusNode _nodeText = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        color: ColorData.colorsBlack.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Dimen.border),
      ),
      child: TextField(
        readOnly: widget.isReadAble,
        textAlignVertical: TextAlignVertical.center,
        minLines: 1,
        maxLines: 1,
        focusNode: _nodeText,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged(value);
          }
        },
        onTap: () {
          if (widget.onTaped != null) {
            widget.onTaped();
          }
        },
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 16, top: 11, bottom: 11),
            child: Image.asset(
              'assets/images/ic_search.png',
              width: 24,
              height: 24,
              color: ColorData.colorsBlack,
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 16),
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: ColorData.textGray.withOpacity(0.6),
            fontSize: FontsSize.normal,
          ),
        ),
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