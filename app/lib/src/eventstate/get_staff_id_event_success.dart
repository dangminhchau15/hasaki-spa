import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/staff_id_response.dart';

class GetStaffIdEventSuccess extends BaseEvent {
   StaffIdResponse staffIdResponse;

   GetStaffIdEventSuccess({this.staffIdResponse});
}