import 'package:app/src/base/base_event.dart';

class AddItemEvent extends BaseEvent {
  int consultantId;
  String sku;
  int quantity;
  String note;

  AddItemEvent({this.consultantId, this.sku, this.quantity, this.note});
}
