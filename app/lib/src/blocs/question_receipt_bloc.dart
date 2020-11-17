import 'package:app/src/base/base_bloc.dart';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/network_service_response.dart';
import 'package:app/src/eventstate/get_receipt_event.dart';
import 'package:app/src/eventstate/post_feedback_event.dart';
import 'package:app/src/eventstate/post_feedback_success_event.dart';
import 'package:app/src/models/receipt_response.dart';
import 'package:app/src/utils/string_util.dart';

class QuestionReceiptBloc extends BaseBloc {
  DataRepository dataRepository;

  QuestionReceiptBloc(String username) {
    dataRepository = DataRepository(username);
  }

  Future<NetworkServiceResponse<Receipt>> getReceipt(String filter) async {
    try {
      var result = await dataRepository.getReceipt(filter);
      print(result);
      if (result.isSuccess) {
        print('done searchReceipt');
        return result;
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false,
            message: result.message ?? StringUtil.errorGetReceipt));
      }
    } catch (_) {
      print('searchReceipt error');
    }
  }

  Future<NetworkServiceResponse<Receipt>> getReceiptByBarCode(
      String filter) async {
    try {
      showLoading();
      var result = await dataRepository.getReceipt(filter);
      print(result);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        print('done searchReceipt');
        return result;
      } else {
        hideLoading(NetworkServiceResponse(
            isSuccess: false,
            message: result.message ?? StringUtil.errorGetReceipt));
      }
    } catch (_) {
      print('searchReceipt error');
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  void postFeedback(PostFeedbackEvent event) async {
    try {
      showLoading();
      var result = await dataRepository.postFeedback(event);
      if (result.isSuccess) {
        hideLoading(NetworkServiceResponse(isSuccess: true, message: ""));
        processEventSink.add(
            PostFeedbackSuccessEvent(feedbackResponse: result.bodyResponse));
      } else {
        hideLoading(
            NetworkServiceResponse(isSuccess: false, message: StringUtil.errorGetQuestion));
      }
    } catch (_) {
      hideLoading(NetworkServiceResponse(
          isSuccess: false, message: StringUtil.errorConnection));
    }
  }

  

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case PostFeedbackEvent:
        postFeedback(event);
        break;
    }
  }
}
