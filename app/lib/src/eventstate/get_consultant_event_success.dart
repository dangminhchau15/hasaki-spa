import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/consultant_response.dart';

class GetConsultantEventSuccess extends BaseEvent {
  
  ConsultantResponse response;

  GetConsultantEventSuccess({this.response});
  
}