import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/consultant_detail_response.dart';

class GetConsultantEventDetailSuccess extends BaseEvent {
  ConsultantDetailResponse response;

  GetConsultantEventDetailSuccess({this.response});
}