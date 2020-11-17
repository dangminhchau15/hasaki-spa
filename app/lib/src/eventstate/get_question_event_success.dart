import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/question_response.dart';

class GetQuestionSuccessEvent extends BaseEvent {
  QuestionResponse questionResponse;

  GetQuestionSuccessEvent({this.questionResponse});
}