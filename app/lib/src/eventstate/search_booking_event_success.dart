import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/search_booking_response.dart';

class SearchBookingEventSuccess extends BaseEvent {
  SearchBookingResponse response;

  SearchBookingEventSuccess({this.response});
}