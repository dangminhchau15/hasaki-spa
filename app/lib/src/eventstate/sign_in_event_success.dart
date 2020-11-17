import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/sign_in_response.dart';

class SignInEventSucess extends BaseEvent {
  SignInResponse signInResponse;
  SignInEventSucess({this.signInResponse});
}