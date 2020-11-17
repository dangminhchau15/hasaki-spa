import 'package:app/src/base/base_event.dart';

class BookingEvent extends BaseEvent {
  String bookingDate;
  String decs;
  String name;
  String phone;
  int status;
  String serviceGroupSku;
  String staffId;
  int storeId;

  BookingEvent({
    this.bookingDate,
    this.decs,
    this.name,
    this.phone,
    this.status,
    this.serviceGroupSku,
    this.staffId,
    this.storeId
  });
}
