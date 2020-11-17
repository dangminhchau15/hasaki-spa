import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/add_item_receipt_response.dart';

class AddItemEventSuccess extends BaseEvent {
  AddItemResponse response;

  AddItemEventSuccess({this.response});
}