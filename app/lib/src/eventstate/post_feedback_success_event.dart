import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/feedback_response.dart';

class PostFeedbackSuccessEvent extends BaseEvent {
  FeedbackResponse feedbackResponse;

  PostFeedbackSuccessEvent({this.feedbackResponse});
}