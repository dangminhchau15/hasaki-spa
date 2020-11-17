import 'package:app/src/base/base_event.dart';

class GetServiceGroupEvent extends BaseEvent {
  int serviceGroupStatus;
  int serviceGroupParent;
  String sort;

  GetServiceGroupEvent(
      {this.serviceGroupStatus, 
      this.serviceGroupParent, 
      this.sort
      });
}
