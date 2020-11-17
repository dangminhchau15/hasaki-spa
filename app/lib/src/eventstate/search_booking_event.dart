import 'package:app/src/base/base_event.dart';

class SearchBookingEvent extends BaseEvent {
  String date;
  String storeId;
  String staffId;
  String status;
  String importId;
  String code;

  SearchBookingEvent({
    this.date,
    this.storeId,
    this.staffId,
    this.status,
    this.importId,
    this.code
  });
}