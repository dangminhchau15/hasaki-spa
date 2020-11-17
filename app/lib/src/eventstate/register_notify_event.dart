import 'package:app/src/base/base_event.dart';

class RegisterNotifyEvent extends BaseEvent {
  String token;
  String deviceType;
  int appId;

  RegisterNotifyEvent({this.token, this.deviceType, this.appId});
  
}