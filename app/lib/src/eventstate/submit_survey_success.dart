import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/survey_response.dart';

class SubmitSurveySuccess extends BaseEvent {
  SurveyResponse surveyResponse;

  SubmitSurveySuccess({this.surveyResponse});
}