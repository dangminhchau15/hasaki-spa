import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/profile_response.dart';

class GetProfileEventSuccess extends BaseEvent {
  ProfileResponse profileResponse;
  GetProfileEventSuccess({this.profileResponse});
}
