import 'package:app/src/base/base_event.dart';

class GetConsultantEvent extends BaseEvent {
  String fromDate;
  String customerPhone;
  int status;
  int limit;
  int offset;

  GetConsultantEvent(
      {this.fromDate,
      this.customerPhone,
      this.status,
      this.limit,
      this.offset});
}
