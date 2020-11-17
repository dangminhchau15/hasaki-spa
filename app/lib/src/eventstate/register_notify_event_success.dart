import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/register_notify_response.dart';

class RegisterNotifyEventSuccess extends BaseEvent {
  RegisterNotifyResponse registerNotifyResponse;

  RegisterNotifyEventSuccess({this.registerNotifyResponse});
}