import 'dart:async';

import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/question_bloc.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/get_question_event.dart';
import 'package:app/src/eventstate/get_question_event_success.dart';
import 'package:app/src/eventstate/get_staff_id_event.dart';
import 'package:app/src/eventstate/get_staff_id_event_success.dart';
import 'package:app/src/models/question_group.dart';
import 'package:app/src/models/question_response.dart';
import 'package:app/src/models/survey_request.dart';
import 'package:app/src/screens/main/main_screen.dart';
import 'package:app/src/screens/question/question_item.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatelessWidget {
  String receiptCode;
  int customerFeedbackId;

  QuestionScreen({this.receiptCode, this.customerFeedbackId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        appBar: CustomAppBar(
          title: "Phản Hồi",
          isHaveBackButton: true,
        ),
        body: Provider<QuestionBloc>.value(
          value: QuestionBloc(PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
          child: Consumer<QuestionBloc>(
              builder: (context, bloc, child) => QuestionContent(
                    questionBloc: bloc,
                    receiptCode: receiptCode,
                    customerFeedbackId: customerFeedbackId,
                  )),
        ));
  }
}

class QuestionContent extends StatefulWidget {
  QuestionBloc questionBloc;
  String receiptCode;
  int customerFeedbackId;

  QuestionContent(
      {this.questionBloc, this.receiptCode, this.customerFeedbackId});

  _QuestionContentState createState() => _QuestionContentState();
}

class _QuestionContentState extends State<QuestionContent>
    with AutomaticKeepAliveClientMixin<QuestionContent> {
  StreamSubscription _loadingStream;
  bool isLoaded = false;
  bool isEnabled = true;
  double ITEM_HEIGHT = 230.0;
  int staffId = 0;
  List<QuestionGroup> questionGroup = [];
  String barCode = "";
  ScrollController _scrollController;
  QuestionResponse questionResponse;
  QuestionBloc questionBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    questionBloc = widget.questionBloc;
    _loadingStream = apiSubscription(questionBloc.loadingStream, context, null);
    questionBloc.event.add(GetQuestionEvent(receiptCode: widget.receiptCode));
    questionBloc.submitSurveytream.listen((surveyResponse) {
      setState(() {
        isEnabled = false;
        for (var item in questionGroup) {
          item.notSelected = false;
        }
      });
      showOkDialog(
          context,
          "Cảm ơn bạn đã đánh giá dịch vụ của hasaki \n \nVui lòng xem kết quả",
          () => {
                _scrollController.animateTo(ITEM_HEIGHT,
                    duration: new Duration(seconds: 1), curve: Curves.easeInOut)
              },
          true);
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < questionGroup.length; i++) {
      if (questionGroup.elementAt(i).notSelected) {
        _scrollController.animateTo(i * ITEM_HEIGHT,
            duration: new Duration(seconds: 1), curve: Curves.easeInOut);
        break;
      }
    }
    return BlocListener<QuestionBloc>(
      listener: handleEvent,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: StreamBuilder<bool>(
                        initialData: false,
                        stream: questionBloc.loadedListStream,
                        builder: (context, snapshot) {
                          if (snapshot.data) {
                            return ListView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: questionGroup
                                  .map((e) => QuestionItem(
                                        questionGroup: e,
                                        isEnabled: isEnabled,
                                      ))
                                  .toList(),
                            );
                          }
                          return Container();
                        })),
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: ButtonColorNormal(
                        onPressed: () {
                          isEnabled
                              ? _submitSurvey(questionGroup)
                              : Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        },
                        colorData: ColorData.primaryColor,
                        content: Text(
                          isEnabled ? "Gửi kết quả" : "Tiếp tục",
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

  void _scrollToIndex() {
    setState(() {
      for (var item in questionGroup) {
        if (item.answerId == -1) {
          item.notSelected = true;
        } else {
          item.notSelected = false;
        }
      }
    });
  }

  _submitSurvey(List<QuestionGroup> questionGroup) {
    SurveyRequest surveyRequest = SurveyRequest();
    surveyRequest.questions = [];
    surveyRequest.customerFeedbackId = widget.customerFeedbackId;
    surveyRequest.receiptCode = widget.receiptCode;
    surveyRequest.staffId = staffId;
    int notChoosedAnswer = 0;
    for (var i = 0; i < questionGroup.length; i++) {
      List<AnswerRequest> answers = [];
      answers.add(AnswerRequest(
          answerId: questionGroup[i].answerId,
          answerText: questionGroup[i].questionType == 1
              ? questionGroup[i].answerText
              : ""));
      surveyRequest.questions.add(QuestionRequest(
          skuCode: questionGroup[i].skuCode,
          questionId: questionGroup[i].questionId,
          answers: answers));
      if (questionGroup[i].answerId == -1) {
        notChoosedAnswer++;
      }
    }
    if (notChoosedAnswer > 0) {
      _scrollToIndex();
    } else {
      questionBloc.submitSurvey(surveyRequest);
    }
    print("${surveyRequest.toJson()}");
  }

  void handleEvent(BaseEvent event) {
    if (event is GetQuestionSuccessEvent) {
      questionResponse = event.questionResponse;
      for (var i = 0; i < event.questionResponse.data.questions.length; i++) {
        questionGroup.add(QuestionGroup(
            event.questionResponse.data.questions[i].questionType == 1 ? 0 : -1,
            event.questionResponse.data.questions[i].serviceSku,
            event.questionResponse.data.questions[i].questionType,
            "",
            false,
            ITEM_HEIGHT,
            event.questionResponse.data.questions[i].questionId,
            event.questionResponse.data.questions[i].questionTitle,
            event.questionResponse.data.questions[i].answers));
      }
      questionBloc.loadedListSink.add(true);
      questionBloc.event
          .add(GetStaffIdEvent(receiptCode: widget.receiptCode, extraId: -1));
    } else if (event is GetStaffIdEventSuccess) {
      staffId = event.staffIdResponse.data.staffId;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
