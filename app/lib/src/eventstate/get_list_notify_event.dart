import 'package:app/src/base/base_event.dart';

class GetNotifyEvent extends BaseEvent {
  int appId;
  int limit;
  int offset;
  int type;

  GetNotifyEvent({this.appId, this.limit, this.offset, this.type});
}
