import 'dart:async';

import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/question_receipt_bloc.dart';
import 'package:app/src/commonview/base_widget.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/commonview/search_textfield.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/enums/device_screen_type.dart';
import 'package:app/src/eventstate/post_feedback_event.dart';
import 'package:app/src/eventstate/post_feedback_success_event.dart';
import 'package:app/src/models/receipt_response.dart';
import 'package:app/src/screens/question/question_screen.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/debouncer.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class QuestionReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: CustomAppBar(
          title: "Phản Hồi",
          isHaveBackButton: true,
        ),
        body: Provider<QuestionReceiptBloc>.value(
          value: QuestionReceiptBloc(
              PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
          child: Consumer<QuestionReceiptBloc>(
              builder: (context, bloc, child) => QuestionReceiptContentScreen(
                    bloc: bloc,
                  )),
        ));
  }
}

class QuestionReceiptContentScreen extends StatefulWidget {
  QuestionReceiptBloc bloc;

  QuestionReceiptContentScreen({this.bloc});

  QuestionReceiptContentScreenState createState() =>
      QuestionReceiptContentScreenState();
}

class QuestionReceiptContentScreenState
    extends State<QuestionReceiptContentScreen> {
  QuestionReceiptBloc bloc;
  QuestionReceiptBloc feedbackBloc;
  StreamSubscription loadingStream;
  StreamSubscription loadingFeedbackStream;
  String _filter;
  Receipt data;
  final Debouncer _onSearchDebouncer =
      Debouncer(delay: Duration(milliseconds: 500));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedbackBloc = widget.bloc;
    bloc = QuestionReceiptBloc(
        PreferenceProvider.getString(SharePrefNames.USER_NAME, def: ""));
    loadingStream = apiSubscription(bloc.loadingStream, context, null);
    loadingFeedbackStream =
        apiSubscription(feedbackBloc.loadingStream, context, null);
    _filter = "";
  }

  void _searchReceipt() async {
    var result = await bloc.getReceipt(_filter);
    if (result.isSuccess) {
      setState(() {
        data = result?.bodyResponse;
      });
    }
  }

  void _getReceiptByCode() async {
    var result = await bloc.getReceiptByBarCode(_filter);
    if (result.isSuccess) {
      setState(() {
        data = result?.bodyResponse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionReceiptBloc>(
      listener: handleEvent,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 16, top: 12, bottom: 12),
                  child: Container(
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: SearchTextField(
                          isReadAble: false,
                          hintText: "Nhập receipt code",
                          onChanged: (text) {
                            _filter = text;
                            data = Receipt();
                            _onSearchDebouncer.debounce(() {
                              _searchReceipt();
                            });
                          },
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () => {_scanBarCode()},
                            child: Image.asset(
                              "assets/images/ic_scan.png",
                              width: 40,
                              height: 40,
                            ),
                          )),
                    ],
                  )),
                ),
              ),
              Expanded(
                flex: 4,
                child: _receiptItem(data),
              ),
              Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: ButtonColorNormal(
                        onPressed: () {
                          if (data != null) {
                            feedbackBloc.event.add(PostFeedbackEvent(
                                customerId: data.customer.customerId,
                                customerPhone: data.customer.customerPhone,
                                receiptCode: data.receiptCode.toString(),
                                methodFeedback: 0));
                          } else {
                            showOkDialog(context, "Vui lòng chọn hoá đơn!",
                                () => {}, true);
                          }
                        },
                        colorData: ColorData.primaryColor,
                        content: Text(
                          "Đánh giá dịch vụ",
                          style: TextStyle(
                              color: ColorData.colorsWhite,
                              fontFamily: FontsName.textRobotoMedium,
                              fontSize: FontsSize.large),
                        ),
                        border: 30,
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _receiptItem(Receipt data) {
    return BaseWidget(builder: (context, sizingInformation) {
      if (sizingInformation.deviceType == DeviceScreenType.Tablet &&
          sizingInformation.orientation == Orientation.landscape) {
        return _tabletLayoutLandscape(data);
      } else if (sizingInformation.deviceType == DeviceScreenType.Tablet &&
          sizingInformation.orientation == Orientation.portrait) {
        return _tabletLayoutPortrait(data);
      } else {
        return _mobileLayout(data);
      }
    });
  }

  Widget _tabletLayoutPortrait(Receipt data) {
    return data?.customer != null
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: EdgeInsets.only(top: 100, left: 160),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 160),
                        child: Text("Hoá Đơn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontsSize.xlarge,
                                fontFamily: FontsName.textHelveticaNeueBold))),
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "Họ Tên: ",
                          style: TextStyle(
                              fontSize: FontsSize.xlarge,
                              fontFamily: FontsName.textHelveticaNeueRegular),
                        )),
                        Expanded(
                            child: Text("${data?.customer.customerName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontsSize.xlarge,
                                    fontFamily:
                                        FontsName.textHelveticaNeueBold))),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "Số điện thoại: ",
                          style: TextStyle(
                              fontSize: FontsSize.xlarge,
                              fontFamily: FontsName.textHelveticaNeueRegular),
                        )),
                        Expanded(
                            child: Text("${data?.customer.customerPhone}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontsSize.xlarge,
                                    fontFamily:
                                        FontsName.textHelveticaNeueBold))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _tabletLayoutLandscape(Receipt data) {
    return data?.customer != null
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 240),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 260),
                        child: Text("Hoá Đơn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontsSize.xlarge,
                                fontFamily: FontsName.textHelveticaNeueBold))),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "Họ Tên: ",
                          style: TextStyle(
                              fontSize: FontsSize.xlarge,
                              fontFamily: FontsName.textHelveticaNeueRegular),
                        )),
                        Expanded(
                            child: Text("${data?.customer.customerName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontsSize.xlarge,
                                    fontFamily:
                                        FontsName.textHelveticaNeueBold))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _mobileLayout(Receipt data) {
    return data?.customer != null
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: EdgeInsets.only(top: 40, left: 40),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Text("Hoá Đơn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontsSize.large,
                                fontFamily: FontsName.textHelveticaNeueBold))),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "Họ Tên: ",
                          style: TextStyle(
                              fontSize: FontsSize.large,
                              fontFamily: FontsName.textHelveticaNeueRegular),
                        )),
                        Expanded(
                            child: Text("${data?.customer.customerName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontsSize.large,
                                    fontFamily:
                                        FontsName.textHelveticaNeueBold))),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          "Số điện thoại: ",
                          style: TextStyle(
                              fontSize: FontsSize.large,
                              fontFamily: FontsName.textHelveticaNeueRegular),
                        )),
                        Expanded(
                            child: Text("${data?.customer.customerPhone}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontsSize.large,
                                    fontFamily:
                                        FontsName.textHelveticaNeueBold))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  void handleEvent(BaseEvent event) {
    if (event is PostFeedbackSuccessEvent) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QuestionScreen(
                  receiptCode: event.feedbackResponse.data.feedback.receiptCode,
                  customerFeedbackId:
                      event.feedbackResponse.data.feedback.customerFeedbackId,
                )),
      );
    }
  }

  Future _scanBarCode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#33f573", "Huỷ", false, ScanMode.DEFAULT);
    if (barcodeScanRes != "-1") {
      _filter = barcodeScanRes;
      _getReceiptByCode();
    }
  }
}
