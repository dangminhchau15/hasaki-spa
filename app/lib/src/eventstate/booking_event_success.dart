import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/booking_response.dart';

class BookingEventSuccess extends BaseEvent {
  BookingResponse response;

  BookingEventSuccess({this.response});
  
}