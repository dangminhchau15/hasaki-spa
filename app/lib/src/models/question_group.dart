import 'package:app/src/models/question_response.dart';

class QuestionGroup {
  final questionId;
  final String title;
  final List<Answer> children;
  String answerText;
  bool notSelected;
  double itemHeight;
  int answerId;
  int skuCode;
  int questionType;

  QuestionGroup(
      this.answerId, 
      this.skuCode,
      this.questionType,
      this.answerText,
      this.notSelected,
      this.itemHeight,
      this.questionId, 
      this.title,
      [this.children = const <Answer>[]]);
}
