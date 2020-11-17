import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/check_customer_phone_response.dart';

class CheckCustomerPhoneEventSuccess extends BaseEvent {
  CheckCustomerPhoneResponse response;

  CheckCustomerPhoneEventSuccess({this.response});
}