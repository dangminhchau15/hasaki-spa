import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/get_list_notify_response.dart';

class GetListNotifyEventSuccess extends BaseEvent {
  GetListNotifyResponse getListNotifyResponse;

  GetListNotifyEventSuccess({this.getListNotifyResponse});
}