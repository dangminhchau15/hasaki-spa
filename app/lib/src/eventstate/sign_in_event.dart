import 'package:app/src/base/base_event.dart';

class SignInEvent extends BaseEvent {
  String email;
  String password;

  SignInEvent({
    this.email,
    this.password
  });
} 