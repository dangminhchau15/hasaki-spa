import 'package:app/src/base/base_event.dart';

class GetTotalNotifyEvent extends BaseEvent {
  int appId;

  GetTotalNotifyEvent({this.appId});
}