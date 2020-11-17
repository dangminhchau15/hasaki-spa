import 'package:app/src/base/base_event.dart';

class GetReceiptEvent extends BaseEvent {
  String receiptCode;

  GetReceiptEvent({this.receiptCode});
}