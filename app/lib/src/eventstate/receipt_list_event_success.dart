import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/receipt_list_response.dart';

class ReceiptListEventSuccess extends BaseEvent {
  ReceiptListResponse response;

  ReceiptListEventSuccess({this.response});
  
}