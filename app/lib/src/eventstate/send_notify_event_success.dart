import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/feedback_notify_response.dart';

class SendNotifyEventSuccess extends BaseEvent {
  FeedbackNotifyResponse feedbackNotifyResponse;

  SendNotifyEventSuccess({this.feedbackNotifyResponse});
}