import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/models/question_group.dart';
import 'package:app/src/models/question_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';

class QuestionItem extends StatelessWidget {
  final QuestionGroup questionGroup;
  bool isEnabled;

  QuestionItem({this.questionGroup, this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return QuestionItemContent(
      questionGroup: questionGroup,
      isEnabled: isEnabled,
    );
  }
}

class QuestionItemContent extends StatefulWidget {
  QuestionGroup questionGroup;
  bool isEnabled;

  QuestionItemContent({this.questionGroup, this.isEnabled});
  _QuestionItemContentState createState() => _QuestionItemContentState();
}

class _QuestionItemContentState extends State<QuestionItemContent>
    with AutomaticKeepAliveClientMixin<QuestionItemContent> {
  Answer selectedAnswer;

  @override
  Widget build(BuildContext context) {
    if (widget.questionGroup.children.isEmpty)
      return ListTile(
          title: Text(
        widget.questionGroup.title,
        style: TextStyle(
            color: widget.questionGroup.notSelected
                ? ColorData.colorsRed
                : ColorData.colorsBlack),
      ));
    return Container(
      height: widget.questionGroup.itemHeight,
      child: ExpansionTile(
          initiallyExpanded: true,
          trailing: Icon(Icons.arrow_right, color: Colors.transparent),
          key: PageStorageKey<QuestionGroup>(widget.questionGroup),
          title: Text(
              widget.questionGroup.notSelected
                  ? widget.questionGroup.title + "*"
                  : widget.questionGroup.title,
              style: TextStyle(
                  color: widget.questionGroup.notSelected
                      ? ColorData.colorsRed
                      : ColorData.colorsBlack,
                  fontSize: 14)),
          children: [
            _buidAnswerItem(widget.questionGroup.questionType,
                widget.questionGroup.children)
          ]),
    );
  }

  setSelectedAnswer(Answer answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  Widget _buidAnswerItem(int questionType, List<Answer> answers) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        key: PageStorageKey('myScrollable'),
        shrinkWrap: true,
        itemCount: answers.length,
        itemBuilder: (BuildContext context, int index) => questionType == 0
            ? RadioListTile<Answer>(
                value: answers[index],
                groupValue: selectedAnswer,
                activeColor: ColorData.primaryColor,
                title: Text(answers[index].answerContent),
                onChanged: (currentAnswer) {
                  widget.questionGroup.answerId = currentAnswer.answerId;
                  if (widget.isEnabled) {
                    setSelectedAnswer(currentAnswer);
                  }
                },
                selected: selectedAnswer == answers[index],
              )
            : Padding(
                padding: EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 8),
                child: TextFieldOutline(
                  isPassword: 0,
                  height: 100,
                  readOnly: widget.isEnabled ? false : true,
                  hintText: "Vui lòng cho biết ý kiến",
                  isPhoneNumber: false,
                  onChanged: (value) {
                    return widget.questionGroup.answerText = value;
                  },
                )));
  }

  @override
  bool get wantKeepAlive => true;
}
