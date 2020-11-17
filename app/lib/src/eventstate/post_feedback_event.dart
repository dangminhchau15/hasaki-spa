import 'package:app/src/base/base_event.dart';

class PostFeedbackEvent extends BaseEvent {
  int customerId;
  int methodFeedback;
  String customerPhone;
  String receiptCode;

  PostFeedbackEvent(
      {this.customerId,
      this.methodFeedback,
      this.customerPhone,
      this.receiptCode});
}
