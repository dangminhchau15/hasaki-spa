import 'package:app/src/base/base_event.dart';

class SignInEventFalied extends BaseEvent {
  String msg;
  SignInEventFalied({this.msg});
}