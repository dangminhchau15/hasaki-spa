import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/notify_detail_response.dart';

class GetNotifyDetailEventSuccess extends BaseEvent {
  NotifyDetailResponse notifyDetailResponse;

  GetNotifyDetailEventSuccess({this.notifyDetailResponse});
}