import 'package:app/src/commonview/button_outline.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'button_color_normal.dart';
import 'container_dialog.dart';

typedef OnClickOK();
typedef OnClickYes();
typedef OnClickNo();
typedef OnChangeDate(DateTime picked);
typedef OnChangeDateTime(DateTime picked);

GlobalKey _scaffold = GlobalKey();

showDialogUnauth(BuildContext context, NetworkServiceResponse snapshot,
    OnClickOK onClickOK) {
  showOkDialog(
      context,
      '${snapshot.message}',
      () => {
            if (onClickOK != null) {onClickOK()}
          },
      false);
}

showProgress(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SpinKitFadingCircle(color: ColorData.primaryColor),
  );
}

showDatePickerDialog(BuildContext context, bool havePreviousDate,
    DateTime _selectedDate, OnChangeDate onChangeDate) async {
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2015, 8),
    lastDate: havePreviousDate
        ? DateTime(2101)
        : DateTime.now().subtract(Duration(days: 0)),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: ColorData.primaryColor,
          accentColor: ColorData.primaryColor,
          colorScheme: ColorScheme.light(primary: ColorData.primaryColor),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child,
      );
    },
  );
  if (picked != null && picked != _selectedDate) {
    onChangeDate(picked);
  }
}

showDateTimePickerDialog(BuildContext context, OnChangeDateTime onChangeDate) async {
  DatePicker.showDateTimePicker(context,
      showTitleActions: true,
      minTime: DateTime(2020, DateTime.now().month, DateTime.now().day, 00, 00),
      maxTime: DateTime(2020, 12, 31, 00, 00),
      onChanged: (date) {}, onConfirm: (date) {
        onChangeDate(date);
  }, locale: LocaleType.vi);
}

fetchApiResult(BuildContext context, NetworkServiceResponse snapshot,
    OnClickOK onClickOK) {
  showOkDialog(
      context,
      '${snapshot.message}',
      () => {
            // Navigator.pop(context),
            if (onClickOK != null) {onClickOK()}
          },
      true);
}

hideProgress(BuildContext context) {
  Navigator.of(context).pop();
}

showYesNoDialog(BuildContext context, String content, OnClickYes onClickYes,
    OnClickNo onClickNo) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: ContainerDialog(
                height: MediaQuery.of(context).size.height * 0.4,
                content: Container(
                  color: ColorData.background,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: Center(
                          child: Container(
                              height: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "$content",
                                  style: TextStyle(fontSize: FontsSize.large),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 40,
                                child: ButtonOutline(
                                  colorBackground: ColorData.colorsWhite,
                                  colorOutline: ColorData.primaryColor,
                                  content: Text("Quay lại"),
                                  onPressed: () => {
                                    Navigator.pop(context),
                                    if (onClickNo != null) {onClickNo()}
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 40,
                                child: ButtonColorNormal(
                                  colorData: ColorData.primaryColor,
                                  content: Text("Đồng ý",
                                      style: TextStyle(
                                          fontFamily: FontsName
                                              .textHelveticaNeueRegular,
                                          color: ColorData.colorsWhite)),
                                  onPressed: () => {
                                    if (onClickYes != null) {onClickYes()}
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}

showOkDialog(BuildContext context, String content, OnClickOK onClickOK,
    bool clickoutSide) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: ContainerDialog(
                height: MediaQuery.of(context).size.height * 0.4,
                content: Container(
                  color: ColorData.background,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: Center(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "$content",
                                  style: TextStyle(fontSize: FontsSize.large),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          height: 40,
                          child: ButtonColorNormal(
                            colorData: ColorData.primaryColor,
                            content: Text("Đồng ý",
                                style: TextStyle(
                                    fontFamily:
                                        FontsName.textHelveticaNeueRegular,
                                    color: ColorData.colorsWhite)),
                            onPressed: () => {
                              Navigator.of(context).pop(),
                              if (onClickOK != null) {onClickOK()}
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: clickoutSide,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}
