import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/get_total_notify_response.dart';

class GetTotalNotifyEventSuccess extends BaseEvent {
  GetTotalNotifyResponse getTotalNotifyResponse;

  GetTotalNotifyEventSuccess({this.getTotalNotifyResponse});
}