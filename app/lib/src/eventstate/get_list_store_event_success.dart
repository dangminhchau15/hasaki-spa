import 'package:app/src/base/base_event.dart';
import 'package:app/src/models/get_iist_store_response.dart';

class GetListStoreEventSuccess extends BaseEvent {
  GetListStoreResponse response;

  GetListStoreEventSuccess({this.response});
}