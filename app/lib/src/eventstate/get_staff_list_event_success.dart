import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/get_staff_list_response.dart';

class GetStaffListEventSuccess extends BaseEvent {
  List<Staff> response;

  GetStaffListEventSuccess({this.response});
  
}