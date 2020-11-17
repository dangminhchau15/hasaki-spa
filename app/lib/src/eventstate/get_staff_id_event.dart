import 'package:app/src/base/base_event.dart';

class GetStaffIdEvent extends BaseEvent {
  String receiptCode;
  int extraId;

  GetStaffIdEvent({this.receiptCode, this.extraId});
}