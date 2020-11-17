import 'package:app/src/base/base_event.dart';

class GetStaffListEvent extends BaseEvent {
  String sort;
  int limit;
  String q;

  GetStaffListEvent({this.sort, this.limit, this.q});
}
