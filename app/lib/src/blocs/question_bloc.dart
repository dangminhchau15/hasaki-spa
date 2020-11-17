import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/eventstate/get_question_event.dart';
import 'package:app/src/eventstate/get_question_event_success.dart';
import 'package:app/src/eventstate/get_staff_id_event.dart';
import 'package:app/src/eventstate/get_staff_id_event_success.dart';
import 'package:app/src/eventstate/submit_survey_success.dart';
import 'package:app/src/models/survey_request.dart';
import 'package:app/src/models/survey_response.dart';
import 'package:app/src/utils/string_util.dart';
import 'package:rxdart/rxdart.dart';

class QuestionBloc extends BaseBloc {
  DataRepository dataRepository;
  final _submitSurveySubject = PublishSubject<SurveyResponse>();
  final _loadedListSubject = PublishSubject<bool>();
  Stream<SurveyResponse> get submitSurveytream => _submitSurveySubject.stream;
  Sink<SurveyResponse> get submitSurveySink => _submitSurveySubject.sink;

  Stream<bool> get loadedListStream => _loadedListSubject.stream;
  Sink<bool> get loadedListSink => _loadedListSubject.sink;

  QuestionBloc(String username) {
    dataRepository = DataRepository(username);
  }

  void getQuestion(GetQuestionEvent event) async {
    try {
      showLoading();
      var result = await dataRepository.getQuestion(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink.add(
            GetQuestionSuccessEvent(questionResponse: result.bodyResponse));
      } else {
        hideLoading(
            NetworkServiceResponse(isSuccess: false, message: StringUtil.errorGetQuestion));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void getStaffId(GetStaffIdEvent event) async {
    try {
      var result = await dataRepository.getStaffId(event);
      if (result.isSuccess) {
        print("success");
        processEventSink
            .add(GetStaffIdEventSuccess(staffIdResponse: result.bodyResponse));
      } else {}
    } catch (_) {}
  }

  void submitSurvey(SurveyRequest surveyRequest) async {
    try {
      showLoading();
      await Future.delayed(Duration(milliseconds: 300));
      var result = await dataRepository.submitSurvey(surveyRequest);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        submitSurveySink.add(result.bodyResponse);
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false,
            message: result.message ?? StringUtil.errorSubmitSurvey));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case GetQuestionEvent:
        getQuestion(event);
        break;
      case GetStaffIdEvent:
        getStaffId(event);
        break;
    }
  }
}
