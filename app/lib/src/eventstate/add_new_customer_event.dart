import 'package:app/src/base/base_event.dart';

class AddNewCustomerEvent extends BaseEvent {
  String phone;
  String name;

  AddNewCustomerEvent({this.phone, this.name});
}