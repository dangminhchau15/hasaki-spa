import 'package:app/src/base/base_event.dart';

class GetProfileEvent extends BaseEvent {
  String dataStore;

  GetProfileEvent({
    this.dataStore
  });
}