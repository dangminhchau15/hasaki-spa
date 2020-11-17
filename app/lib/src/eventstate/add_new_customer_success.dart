import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/add_new_customer_response.dart';

class AddNewCustomerSuccess extends BaseEvent {
  AddNewCustomerResponse response;

  AddNewCustomerSuccess({this.response});
}