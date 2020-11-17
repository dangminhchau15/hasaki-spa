import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/service_response.dart';

class SearchSkuEventSuccess extends BaseEvent{
  ServiceResponse serviceResponse;

  SearchSkuEventSuccess({this.serviceResponse});
}