import 'package:app/src/base/base_event.dart';

class CheckCustomerPhoneFailEvent extends BaseEvent {
  String msg;

  CheckCustomerPhoneFailEvent({this.msg});
}