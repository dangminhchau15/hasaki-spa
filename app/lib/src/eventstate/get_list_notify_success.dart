import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/get_list_notify_response.dart';

class GetListNotifySuccessEvent extends BaseEvent {
  GetListNotifyResponse notifyResponse;

  GetListNotifySuccessEvent({this.notifyResponse});
}
