import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/get_service_group_response.dart';

class GetServiceGroupEventSuccess extends BaseEvent {
  GetServiceGroupResponse response;

  GetServiceGroupEventSuccess({this.response});
}