import 'package:app/src/base/base_event.dart';

class GetQuestionEvent extends BaseEvent {
  String receiptCode;

  GetQuestionEvent({this.receiptCode});
}