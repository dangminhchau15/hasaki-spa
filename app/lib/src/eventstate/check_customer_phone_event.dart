import 'package:app/src/base/base_event.dart';

class CheckCustomerPhoneEvent extends BaseEvent {
  String phone;

  CheckCustomerPhoneEvent({this.phone});
}